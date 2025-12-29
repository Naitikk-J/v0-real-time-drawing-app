const roomManager = require("../server/roomManager")

exports.createRoom = (req, res) => {
  try {
    const code = roomManager.createRoom()
    res.json({ success: true, code })
  } catch (error) {
    res.status(500).json({ success: false, error: error.message })
  }
}

exports.joinRoom = (req, res) => {
  try {
    const { code } = req.body

    if (!code) {
      return res.status(400).json({ success: false, error: "Code required" })
    }

    if (!roomManager.roomExists(code)) {
      return res.status(404).json({ success: false, error: "Room not found" })
    }

    res.json({ success: true, code })
  } catch (error) {
    res.status(500).json({ success: false, error: error.message })
  }
}
