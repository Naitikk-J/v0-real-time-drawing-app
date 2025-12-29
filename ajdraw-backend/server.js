require("dotenv").config()
const express = require("express")
const http = require("http")
const socketIo = require("socket.io")
const cors = require("cors")
const roomRoutes = require("./src/routes/roomRoutes")
const { initializeSocket } = require("./src/server/socket")

const app = express()
const server = http.createServer(app)
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
})

const PORT = process.env.PORT || 3000

// Middleware
app.use(cors())
app.use(express.json())

// Routes
app.use("/api/room", roomRoutes)

// Health check
app.get("/health", (req, res) => {
  res.json({ status: "ok" })
})

// Initialize Socket.IO
initializeSocket(io)

// Start server
server.listen(PORT, () => {
  console.log(`AJdraw server running on port ${PORT}`)
})

module.exports = { app, io }
