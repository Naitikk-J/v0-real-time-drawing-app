const roomManager = require("./roomManager")
const drawManager = require("./drawManager")

function initializeSocket(io) {
  io.on("connection", (socket) => {
    console.log(`User connected: ${socket.id}`)

    socket.on("join_room", (data) => {
      const { code } = data

      if (!roomManager.roomExists(code)) {
        socket.emit("error", { message: "Room does not exist" })
        return
      }

      const roomData = roomManager.joinRoom(code, socket.id)
      socket.join(code)
      drawManager.startDrawing(code, socket.id)

      // Send existing canvas state to new user
      socket.emit("load_canvas", { canvas: roomData.canvas })

      // Notify others
      socket.to(code).emit("user_joined", { userId: socket.id, totalUsers: roomData.room.users.length })

      console.log(`User ${socket.id} joined room ${code}`)
    })

    socket.on("draw_point", (data) => {
      const { roomCode, point } = data

      if (!roomManager.roomExists(roomCode)) {
        return
      }

      // Add to room canvas
      roomManager.addDrawPoint(roomCode, point)
      drawManager.addPoint(roomCode, socket.id, point)

      // Broadcast to all users in room
      io.to(roomCode).emit("broadcast_point", { point, userId: socket.id })
    })

    socket.on("clear_canvas", (data) => {
      const { roomCode } = data

      if (!roomManager.roomExists(roomCode)) {
        return
      }

      roomManager.clearRoom(roomCode)
      drawManager.clearAllRoomDrawings(roomCode)

      // Broadcast clear to all users
      io.to(roomCode).emit("canvas_cleared", {})
      console.log(`Canvas cleared in room ${roomCode}`)
    })

    socket.on("disconnect", () => {
      console.log(`User disconnected: ${socket.id}`)
      // Clean up from all rooms
      const adapter = io.sockets.adapter
      const rooms = adapter.sids.get(socket.id) || new Set()
      rooms.forEach((roomCode) => {
        roomManager.leaveRoom(roomCode, socket.id)
        drawManager.clearDrawing(roomCode, socket.id)
      })
    })
  })
}

module.exports = { initializeSocket }
