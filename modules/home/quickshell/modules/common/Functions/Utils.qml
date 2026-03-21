pragma Singleton

import QtQuick
import Quickshell

QtObject {
  id: root

  property var substitutions: ({
      "code-url-handler": "visual-studio-code",
      "Code": "visual-studio-code",
      "gnome-tweaks": "org.gnome.tweaks",
      "pavucontrol-qt": "pavucontrol",
      "wps": "wps-office2019-kprometheus",
      "wpsoffice": "wps-office2019-kprometheus",
      "footclient": "foot"
    })

  property var regexSubstitutions: [
    {
      "regex": /^steam_app_(\d+)$/,
      "replace": "steam_icon_$1"
    },
    {
      "regex": /Minecraft.*/,
      "replace": "minecraft"
    },
    {
      "regex": /.*polkit.*/,
      "replace": "system-lock-screen"
    },
    {
      "regex": /gcr\.prompter/,
      "replace": "system-lock-screen"
    },
  ]

  function iconExists(iconName) {
    if (!iconName || iconName.length === 0)
      return false;
    return Quickshell.iconPath(iconName, true).length > 0 && !iconName.includes("image-missing");
  }

  function getReverseDomainNameAppName(str) {
    return str.split('.').slice(-1)[0];
  }

  function getKebabNormalizedAppName(str) {
    return str.toLowerCase().replace(/\s+/g, "-");
  }

  function getUnderscoreToKebabAppName(str) {
    return str.toLowerCase().replace(/_/g, "-");
  }

  function guessIcon(str) {
    if (!str || str.length === 0)
      return "image-missing";

    // Desktop entry lookup direto
    const entry = DesktopEntries.byId(str);
    if (entry)
      return entry.icon;

    // Substituições normais
    if (substitutions[str])
      return substitutions[str];
    if (substitutions[str.toLowerCase()])
      return substitutions[str.toLowerCase()];

    // Regex substitutions
    for (let i = 0; i < regexSubstitutions.length; i++) {
      const sub = regexSubstitutions[i];
      const replaced = str.replace(sub.regex, sub.replace);
      if (replaced !== str)
        return replaced;
    }

    // Verificação direta
    if (iconExists(str))
      return str;

    const lowercased = str.toLowerCase();
    if (iconExists(lowercased))
      return lowercased;

    const reverseDomain = getReverseDomainNameAppName(str);
    if (iconExists(reverseDomain))
      return reverseDomain;

    const lowercasedDomain = reverseDomain.toLowerCase();
    if (iconExists(lowercasedDomain))
      return lowercasedDomain;

    const kebab = getKebabNormalizedAppName(str);
    if (iconExists(kebab))
      return kebab;

    const underscoreToKebab = getUnderscoreToKebabAppName(str);
    if (iconExists(underscoreToKebab))
      return underscoreToKebab;

    // Heuristic lookup
    const heuristicEntry = DesktopEntries.heuristicLookup(str);
    if (heuristicEntry)
      return heuristicEntry.icon;

    return "application-x-executable";
  }

  function guessIconPath(str) {
    return Quickshell.iconPath(guessIcon(str));
  }
}
