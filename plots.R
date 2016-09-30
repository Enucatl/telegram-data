#!/usr/bin/env Rscript

library(ggplot2)
library(data.table)
library(argparse)

theme_set(theme_bw(base_size=12) + theme(
    legend.key.size=unit(1, 'lines'),
    text=element_text(face='plain', family='CM Roman'),
    legend.title=element_text(face='plain'),
    axis.line=element_line(color='black'),
    axis.title.y=element_text(vjust=0.1),
    axis.title.x=element_text(vjust=0.1),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.key = element_blank(),
    panel.border = element_blank()
))

commandline_parser = ArgumentParser(
        description="make plots")
commandline_parser$add_argument('-f', '--file',
            type='character', nargs='?', default='data/dump.csv',
            help='file with the data.table')
args = commandline_parser$parse_args()

table = fread(args$f)

table[from_name == "", from_name:="Alessio_Rocca"]

from_hist = ggplot(table) +
    geom_bar(aes(x=reorder(from_name, from_name, function(x) -length(x))), fill="lightblue") +
    theme(axis.text.x = element_text(angle=60, hjust=1, vjust=1)) +
    xlab("") +
    ylab("number of messages")
print(from_hist)

width = 7
factor = 1
height = width * factor

ggsave("plots/from_hist.png", from_hist, width=width, height=height, dpi=300)
invisible(readLines(con="stdin", 1))

