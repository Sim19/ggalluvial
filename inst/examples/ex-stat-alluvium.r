# illustrate positioning
ggplot(as.data.frame(Titanic),
       aes(y = Freq,
           axis1 = Class, axis2 = Sex, axis3 = Age,
           color = Survived)) +
  stat_stratum(geom = "errorbar") +
  geom_line(stat = "alluvium") +
  stat_alluvium(geom = "pointrange") +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("Class", "Sex", "Age"))

# lode ordering examples
gg <- ggplot(as.data.frame(Titanic),
             aes(y = Freq,
                 axis1 = Class, axis2 = Sex, axis3 = Age)) +
  geom_stratum() +
  geom_text(stat = "stratum", aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("Class", "Sex", "Age"))
# use of lode controls
gg + geom_flow(aes(fill = Survived, alpha = Sex), stat = "alluvium",
               lode.guidance = "forward")
# prioritize aesthetic binding
gg + geom_flow(aes(fill = Survived, alpha = Sex), stat = "alluvium",
               aes.bind = TRUE, lode.guidance = "forward")
# use of lode ordering
lode_ord <- replicate(n = 3, expr = sample(x = 32), simplify = FALSE)
print(lode_ord)
gg + geom_flow(aes(fill = Survived, alpha = Sex), stat = "alluvium",
               lode.ordering = lode_ord)
# fixed lode ordering across axes
gg + geom_flow(aes(fill = Survived, alpha = Sex), stat = "alluvium",
               lode.ordering = lode_ord[[1]])
# use of custom luide guidance function
lode_custom <- function(n, i) {
  stopifnot(n == 3)
  switch(
    i,
    `1` = 1:3,
    `2` = c(2, 3, 1),
    `3` = 3:1
  )
}
gg + geom_flow(aes(fill = Survived, alpha = Sex), stat = "alluvium",
               aes.bind = "flow", lode.guidance = lode_custom)

# omit missing elements & reverse the `y` axis
ggplot(ggalluvial::majors,
       aes(x = semester, stratum = curriculum, alluvium = student, y = 1)) +
  geom_alluvium(fill = "darkgrey", na.rm = TRUE) +
  geom_stratum(aes(fill = curriculum), color = NA, na.rm = TRUE) +
  theme_bw() +
  scale_y_reverse()

# alluvium cementation examples
gg <- ggplot(ggalluvial::majors,
             aes(x = semester, stratum = curriculum, alluvium = student,
                 fill = curriculum)) +
  geom_stratum()
# diagram with outlined alluvia and labels
gg + geom_flow(stat = "alluvium", color = "black") +
  geom_text(aes(label = after_stat(lode)), stat = "alluvium")
# cemented diagram with default distillation (first most common alluvium)
gg +
  geom_flow(stat = "alluvium", color = "black", cement.alluvia = TRUE) +
  geom_text(aes(label = after_stat(lode)), stat = "alluvium",
            cement.alluvia = TRUE)
# cemented diagram with custom label distillation
gg +
  geom_flow(stat = "alluvium", color = "black", cement.alluvia = TRUE) +
  geom_text(aes(label = after_stat(lode)), stat = "alluvium",
            cement.alluvia = TRUE,
            distill = function(x) paste(x, collapse = "; "))

\dontrun{
data(babynames, package = "babynames")
# a discontiguous alluvium
bn <- subset(babynames, prop >= .01 & sex == "F" & year > 1962 & year < 1968)
ggplot(data = bn,
       aes(x = year, alluvium = name, y = prop)) +
  geom_alluvium(aes(fill = name, color = name == "Tammy"),
                decreasing = TRUE, show.legend = FALSE) +
  scale_color_manual(values = c("#00000000", "#000000"))
# filling in missing zeros
bn2 <- merge(bn,
             expand.grid(year = unique(bn$year), name = unique(bn$name)),
             all = TRUE)
bn2$prop[is.na(bn2$prop)] <- 0
ggplot(data = bn2,
       aes(x = year, alluvium = name, y = prop)) +
  geom_alluvium(aes(fill = name, color = name == "Tammy"),
                decreasing = TRUE, show.legend = FALSE) +
  scale_color_manual(values = c("#00000000", "#000000"))
}

# use negative y values to encode deaths versus survivals
titanic <- as.data.frame(Titanic)
titanic <- transform(titanic, Lives = Freq * (-1) ^ (Survived == "No"))
ggplot(subset(titanic, Class != "Crew"),
       aes(axis1 = Class, axis2 = Sex, axis3 = Age, y = Lives)) +
  geom_alluvium(aes(alpha = Survived, fill = Class), absolute = FALSE) +
  geom_stratum(absolute = FALSE) +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)),
            absolute = FALSE) +
  scale_x_discrete(limits = c("Class", "Sex", "Age"), expand = c(.1, .05)) +
  scale_alpha_discrete(range = c(.25, .75), guide = FALSE)
