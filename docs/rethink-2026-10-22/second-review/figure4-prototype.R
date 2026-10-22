# Editorial prototype only: reads finalized exports without rerunning analyses.
out <- "docs/rethink-2026-10-22/second-review"
root <- "analysis/output/tables"
est <- read.csv(file.path(root, "independent-estimates.csv"), check.names = FALSE)
dif <- read.csv(file.path(root, "independent-differences.csv"), check.names = FALSE)
pub <- read.csv(file.path(root, "table1-differences.csv"), check.names = FALSE)
domains <- c("D1-D5", paste0("D", 1:5))
labels <- c("Pooled (510 cells)", "D1 Randomization", "D2 Deviations", "D3 Missing data", "D4 Measurement", "D5 Reported result")
cols <- c(ARBITER = "#0072B2", Unassisted = "#D55E00")
get_est <- function(expert, arm) {
  d <- subset(est, metric == "accuracy" & adjudicator == expert & source == arm & population == "All domain cells")
  d[match(domains, d$domain), ]
}
get_diff <- function(expert) {
  d <- subset(dif, metric == "accuracy" & adjudicator == expert & comparison == "ARBITER minus Unassisted" & population == "All domain cells")
  d[match(domains, d$domain), ]
}
draw <- function() {
  layout(matrix(c(1, 2, 3, 4, 5, 5), 3, 2, byrow = TRUE), widths = c(1.5, 1), heights = c(1, 1, .27))
  par(family = "sans", cex = .83, fg = "#20252B", col.axis = "#535B63", col.lab = "#20252B", tcl = -.2, mgp = c(1.8, .5, 0), xaxs = "i", yaxs = "i")
  for (expert in c("1", "2")) {
    a <- get_est(expert, "ARBITER"); u <- get_est(expert, "Unassisted"); d <- get_diff(expert)
    stopifnot(nrow(a) == 6, nrow(u) == 6, nrow(d) == 6, all(a$n == c(510, rep(102, 5))))
    stopifnot(max(abs((a$estimate-u$estimate)-d$estimate)) < 1e-12)
    yy <- 6:1
    par(mar = c(3.2, 9.0, 3.6, .7))
    plot(NA, xlim = c(0, 100), ylim = c(.35, 6.7), axes = FALSE, xlab = "Exact agreement (%)", ylab = "")
    abline(v = seq(0, 100, 25), col = "#E5E7EA", lwd = .6)
    abline(h = 5.5, col = "#B9BFC5", lwd = .6)
    axis(1, at = seq(0, 100, 25), col = "#AAB1B9")
    axis(2, at = yy, labels = labels, las = 1, tick = FALSE, line = -.3, cex.axis = .95)
    for (arm in names(cols)) {
      z <- if (arm == "ARBITER") a else u
      ypos <- yy + if (arm == "ARBITER") .115 else -.115
      segments(100*z$lower, ypos, 100*z$upper, ypos, col = cols[arm], lwd = 1)
      points(100*z$estimate, ypos, pch = if (arm == "ARBITER") 16 else 15, col = cols[arm], cex = .8)
    }
    title(main = paste("Expert", expert), adj = 0, line = 2, cex.main = 1.05)
    mtext(sprintf("Pooled: %.1f%% vs %.1f%%", 100*a$estimate[1], 100*u$estimate[1]), side = 3, adj = 0, line = .7, cex = .78)
    par(mar = c(3.2, 1.8, 3.6, 1))
    plot(NA, xlim = c(-10, 30), ylim = c(.35, 6.7), axes = FALSE, xlab = "Paired difference (percentage points)", ylab = "")
    abline(v = c(-10, 10, 20, 30), col = "#E5E7EA", lwd = .6)
    abline(v = 0, col = "#7E8790", lty = 2, lwd = .8)
    abline(h = 5.5, col = "#B9BFC5", lwd = .6)
    axis(1, at = seq(-10, 30, 10), labels = c("-10", "0", "+10", "+20", "+30"), col = "#AAB1B9")
    segments(100*d$lower, yy, 100*d$upper, yy, lwd = 1.1)
    points(100*d$estimate, yy, pch = 18, cex = .9)
    title(main = "ARBITER minus Unassisted", adj = 0, line = 2, cex.main = .92)
    mtext(sprintf("Pooled: +%.1f (95%% CI %.1f to %.1f)", 100*d$estimate[1], 100*d$lower[1], 100*d$upper[1]), side = 3, adj = 0, line = .7, cex = .78)
  }
  par(mar = c(.3, .8, .3, .8))
  plot.new(); plot.window(xlim = c(0, 1), ylim = c(0, 1))
  segments(0, .94, 1, .94, col = "#AAB1B9", lwd = .7)
  p <- subset(pub, metric == "accuracy" & domain == "D1-D5" & reference == "Published")
  stopifnot(nrow(p) == 1)
  text(0, .65, sprintf("Published-label reference (all 510 cells): paired difference %.1f points (95%% CI %.1f to %.1f)", 100*p$estimate, 100*p$lower, 100*p$upper), adj = 0, cex = .84)
  legend("bottomleft", legend = c("ARBITER", "Unassisted"), pch = c(16, 15), col = cols, horiz = TRUE, bty = "n", cex = .85, inset = c(0, -.05))
}
png(file.path(out, "figure4-prototype.png"), width = 2100, height = 1730, res = 300, bg = "white")
draw(); dev.off()
pdf(file.path(out, "figure4-prototype.pdf"), width = 7, height = 1730/300, useDingbats = FALSE)
draw(); dev.off()
cat("Prototype rendered from 24 absolute estimates and 12 paired contrasts; all paired point estimates reconciled.\n")
