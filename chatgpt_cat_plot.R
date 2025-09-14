# Basic cat face with R base plotting
plot(0, 0, type = "n", xlim = c(-5, 5), ylim = c(-5, 5), asp = 1,
     xaxt = "n", yaxt = "n", xlab = "", ylab = "", bty = "n")

# Face
symbols(0, 0, circles = 4, inches = FALSE, add = TRUE, bg = "lightgray")

# Ears
polygon(c(-2.5, -1, -3.5), c(2, 4.5, 3.5), col = "lightgray", border = "black")
polygon(c(2.5, 1, 3.5), c(2, 4.5, 3.5), col = "lightgray", border = "black")

# Eyes
symbols(-1.2, 0.8, circles = 0.4, inches = FALSE, add = TRUE, bg = "white")
symbols( 1.2, 0.8, circles = 0.4, inches = FALSE, add = TRUE, bg = "white")
points(-1.2, 0.8, pch = 19, cex = 1.5)
points( 1.2, 0.8, pch = 19, cex = 1.5)

# Nose
points(0, 0, pch = 19, cex = 1.2, col = "pink")

# Mouth
lines(c(-0.3, 0, 0.3), c(-0.7, -1.2, -0.7))

# Whiskers
segments(-4, 0, -1.8, 0)
segments(-4, -0.5, -1.8, -0.7)
segments(-4,  0.5, -1.8,  0.7)

segments(4, 0, 1.8, 0)
segments(4, -0.5, 1.8, -0.7)
segments(4,  0.5, 1.8,  0.7)
