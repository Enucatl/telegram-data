#!/usr/bin/env Rscript

library(ggplot2)
library(data.table)
library(argparse)
library(stringr)

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
table[, text_length := nchar(text)]
table[from_name == "", from_name:="Alessio_Rocca"]
n_cazzi_table = table[, list(
    n_cazzi=sum(str_count(tolower(text), "cazz[i|o]"), na.rm=TRUE),
    n=.N
    ), by=from_name]

print(table)
print(n_cazzi_table)



n_cazzi_hist = ggplot(n_cazzi_table[n_cazzi > 0]) +
    geom_bar(aes(x=reorder(from_name, -n_cazzi), y=n_cazzi), fill="lightblue", stat="identity") +
    theme(axis.text.x = element_text(angle=60, hjust=1, vjust=1)) +
    xlab("") +
    ylab("occurrences of 'cazzo'")
dev.new()
print(n_cazzi_hist)
n_cazzi_rel_hist = ggplot(n_cazzi_table[n_cazzi > 0]) +
    geom_bar(aes(x=reorder(from_name, -n_cazzi / n), y=n_cazzi / n), fill="lightblue", stat="identity") +
    theme(axis.text.x = element_text(angle=60, hjust=1, vjust=1)) +
    xlab("") +
    ylab("occurrences of 'cazzo' / total number of messages")
dev.new()
print(n_cazzi_rel_hist)

from_hist = ggplot(table) +
    geom_bar(aes(x=reorder(from_name, from_name, function(x) -length(x))), fill="lightblue") +
    theme(axis.text.x = element_text(angle=60, hjust=1, vjust=1)) +
    xlab("") +
    ylab("number of messages")
dev.new()
print(from_hist)

text_length_boxplot = ggplot(table) +
    geom_boxplot(aes(from_name, text_length)) +
    theme(axis.text.x = element_text(angle=60, hjust=1, vjust=1)) +
    scale_y_log10(breaks=c(10, 100, 1000)) +
    xlab("") +
    ylab("message char length")
dev.new()
print(text_length_boxplot)

width = 7
factor = 1
height = width * factor

ggsave("plots/from_hist.png", from_hist, width=width, height=height, dpi=300)
ggsave("plots/text_length_boxplot.png", text_length_boxplot, width=width, height=height, dpi=300)
ggsave("plots/n_cazzi_hist.png", n_cazzi_hist, width=width, height=height, dpi=300)
ggsave("plots/n_cazzi_rel_hist.png", n_cazzi_rel_hist, width=width, height=height, dpi=300)
invisible(readLines(con="stdin", 1))

