function friendlyAppName(appId, title, entries) {
  var id = String(appId || "")
  var last = id.split(".").pop()
  var values = entries || []
  for (var i = 0; i < values.length; i++) {
    var entry = values[i]
    if (!entry) continue
    var entryId = String(entry.id || "")
    if (entryId === id || entryId === last || entryId === id + ".desktop" || entryId === last + ".desktop")
      return entry.name || last
  }
  if (title && title.indexOf(" - ") >= 0) {
    var parts = title.split(" - ")
    return parts[parts.length - 1]
  }
  return last || title || ""
}
