class RoomManager {
  constructor() {
    this.rooms = new Map()
  }

  createRoom() {
    const { generateRoomCode } = require("../utils/generateCode")
    let code = generateRoomCode()

    // Check if code already exists (extremely rare)
    while (this.rooms.has(code)) {
      code = generateRoomCode()
    }

    this.rooms.set(code, {
      code,
      users: [],
      createdAt: Date.now(),
      canvas: [],
    })

    return code
  }

  joinRoom(code, userId) {
    if (!this.rooms.has(code)) {
      return false
    }

    const room = this.rooms.get(code)
    if (!room.users.includes(userId)) {
      room.users.push(userId)
    }

    return {
      success: true,
      room,
      canvas: room.canvas,
    }
  }

  leaveRoom(code, userId) {
    if (!this.rooms.has(code)) {
      return
    }

    const room = this.rooms.get(code)
    room.users = room.users.filter((id) => id !== userId)

    // Delete room if empty
    if (room.users.length === 0) {
      this.rooms.delete(code)
    }
  }

  roomExists(code) {
    return this.rooms.has(code)
  }

  getRoom(code) {
    return this.rooms.get(code)
  }

  addDrawPoint(code, point) {
    const room = this.getRoom(code)
    if (room) {
      room.canvas.push(point)
    }
  }

  clearRoom(code) {
    const room = this.getRoom(code)
    if (room) {
      room.canvas = []
    }
  }
}

module.exports = new RoomManager()
