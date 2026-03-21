pragma Singleton

import QtQuick
import Quickshell
import QtQuick.LocalStorage

Singleton {
  id: root

  property var db: null

  function getDb() {
    if (!db) {
      db = LocalStorage.openDatabaseSync("AppSearch", "1.0", "App usage tracking", 1000000);
      db.transaction(tx => {
        tx.executeSql('CREATE TABLE IF NOT EXISTS usage (id TEXT PRIMARY KEY, count INTEGER, lastUsed INTEGER)');
      });
    }
    return db;
  }

  function recordUsage(appId) {
    const database = getDb();
    database.transaction(tx => {
      tx.executeSql(`
        INSERT INTO usage (id, count, lastUsed) VALUES (?, 1, ?)
        ON CONFLICT(id) DO UPDATE SET count = count + 1, lastUsed = ?
      `, [appId, Date.now(), Date.now()]);
    });
  }

  function frecencyScore(count, lastUsed) {
    const ageHours = (Date.now() - lastUsed) / 1000 / 60 / 60;
    return count / (1 + ageHours * 0.1);
  }

  function search(query) {
    const database = getDb();
    let results = [];

    database.readTransaction(tx => {
      const rows = tx.executeSql('SELECT id, count, lastUsed FROM usage').rows;
      const usageMap = {};
      for (let i = 0; i < rows.length; i++) {
        const r = rows.item(i);
        usageMap[r.id] = {
          count: r.count,
          lastUsed: r.lastUsed
        };
      }

      const all = DesktopEntries.applications.values.slice();
      const filtered = !query || query.length === 0 ? all : all.filter(a => fuzzyMatch(query, a.name) || fuzzyMatch(query, a.id));

      results = filtered.sort((a, b) => {
        const ua = usageMap[a.id];
        const ub = usageMap[b.id];
        const sa = ua ? frecencyScore(ua.count, ua.lastUsed) : 0;
        const sb = ub ? frecencyScore(ub.count, ub.lastUsed) : 0;
        return sb - sa;
      });
    });

    return results;
  }

  function fuzzyMatch(query, str) {
    if (!query || query.length === 0)
      return true;
    const q = query.toLowerCase();
    const s = str.toLowerCase();
    let qi = 0;
    for (let i = 0; i < s.length && qi < q.length; i++) {
      if (s[i] === q[qi])
        qi++;
    }
    return qi === q.length;
  }
}
