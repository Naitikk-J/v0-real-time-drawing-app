class DrawManager {
  constructor() {
    this.drawings = new Map()
  }

  startDrawing(roomCode, userId) {
    const key = `${roomCode}-${userId}`
    this.drawings.set(key, [])
  }

  addPoint(roomCode, userId, point) {
    const key = `${roomCode}-${userId}`
    if (!this.drawings.has(key)) {
      this.drawings.set(key, [])
    }
    this.drawings.get(key).push(point)
  }

  getDrawing(roomCode, userId) {
    const key = `${roomCode}-${userId}`
    return this.drawings.get(key) || []
  }

  clearDrawing(roomCode, userId) {
    const key = `${roomCode}-${userId}`
    this.drawings.delete(key)
  }

  clearAllRoomDrawings(roomCode) {
    const keysToDelete = []
    for (const key of this.drawings.keys()) {
      if (key.startsWith(roomCode)) {
        keysToDelete.push(key)
      }
    }
    keysToDelete.forEach((key) => this.drawings.delete(key))
  }
}

module.exports = new DrawManager()
