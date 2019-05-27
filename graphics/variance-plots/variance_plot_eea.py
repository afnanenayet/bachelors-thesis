""" This is a script that generates variance plots given the data from the EEA
tool. The script creates a plot of variance on a log scale given variance data.
Output is meant for a latex file.
"""
import os
import sys
from collections import namedtuple
from typing import List, Tuple

import matplotlib
import matplotlib.pyplot as plt
import numpy as np
from numpy.polynomial import polynomial as P
from tqdm import tqdm

plt.rc('text', usetex=True)
plt.rc('font', **{'family': "serif"})
params = {
    'text.latex.preamble': [r'\usepackage{times}', r'\usepackage{mathptmx}'],
    # 'legend.fontsize': 10,
    # 'legend.handlelength': 1
}
plt.rcParams.update(params)

# A type for data elements
Data = namedtuple("Data", ["x", "y"])


def load_file(fname: str, square: bool = False) -> List[Data]:
    """ Load a data file for a particular sampler/sample projection.

    It is assumed that the datafile is a space and newline delimited
    set of data.

    Args:
        - fname: The filename to load
    Returns: A tuple of lists denoting X and y data.
    """
    res = list()

    with open(fname) as file:
        for line in file:
            x_str, y_str = line.split(" ")
            x = int(x_str.strip())

            if square:
                x *= x
            y = float(y_str.strip())
            data = Data(x, y)
            res.append(data)
    res = sorted(res)
    return res


def slope_line(axes, slope: float, intercept: float = 0) -> List[Data]:
    """ Generate the data for a slope line given a slope and intercept. This
    data can be directly fed into matplotlib.

    Args:
        - axes: The axis data from the graph
        - slope: The desired exponential slope (e.g -1 will show up as a line
          with a negative slope on a log scale)
        - intercept: The intercept for the graph
    Returns: A pair of arrays, x and y, that can be plotted using matplotlib
    """
    x = np.array(axes.get_xlim())
    y = x**slope + intercept
    return [Data(x[i], y[i]) for i in range(len(x))]


def best_fit_line(data: List[Data]) -> Tuple[List[Data], float]:
    """ Generate the best fit line for the slope of some convergence graph

    Params:
        - x (an iterable of numbers): the x data
        - y (an iterable of numbers): the y data

    Returns:
        A tuple with the first element being an iterable of data points to
        plot in the graph, and the second element being the slope of the
        graph.
    """
    # convert the data list to vectors so we can perform numpy operations on
    # the data
    x = []
    y = []

    for point in data:
        if point.x != 0 and point.y != 0:
            x.append(point.x)
            y.append(point.y)
    x = np.array(x)
    y = np.array(y)

    # take the logarithm of x, y
    log_x = np.log(x)
    log_y = np.log(y)

    # figure out the slope of a line of best fit
    slope = np.polyfit(log_x, log_y, deg=1)

    # poly is a polynomial in log(x) that returns log(x)
    poly = np.poly1d(slope)

    # the actual y values for the best fit line
    y_best_fit = np.exp(poly(log_x))

    # generate the list of data points to be consumed by the graph
    data_pts = [Data(x[i], y_best_fit[i]) for i in range(len(x))]
    return data_pts, slope[0]


def var_multi_plot(data: list,
                   fname: str,
                   title: str = "Variance Analysis",
                   ax=None):
    """ Generate a variance plot for variances with multiple samplers overlaid
    on the same plot.

    Args:
        - data: A tuple of legend names and data
        - fname: The file name to save the plot to. This will also determine
          the format of the plot
        - ax: The axes to apply to the plot. It should be a tuple of the form
          (xlim, ylim). If none are supplied, the graph will scale
          automatically.
        - title: The title to put on the graph
    Returns: The axis information for the current graph
    """
    plt.clf()
    plt.rc('text', usetex=True)

    SMALL_SIZE = 7
    MEDIUM_SIZE = 8
    BIGGER_SIZE = 10

    plt.rc('font', size=SMALL_SIZE)  # controls default text sizes
    plt.rc('axes', titlesize=SMALL_SIZE)  # fontsize of the axes title
    plt.rc('axes', labelsize=MEDIUM_SIZE)  # fontsize of the x and y labels
    plt.rc('xtick', labelsize=SMALL_SIZE)  # fontsize of the tick labels
    plt.rc('ytick', labelsize=SMALL_SIZE)  # fontsize of the tick labels
    plt.rc('legend', fontsize=MEDIUM_SIZE)  # legend fontsize
    plt.rc('figure', titlesize=BIGGER_SIZE)  # fontsize of the figure title

    fig = plt.figure(figsize=(5, 3))

    # Plot data
    for tup in data:
        if len(tup) == 4:
            legend, d, dec, color = tup
            x = [k.x for k in d]
            y = [k.y for k in d]
            plt.plot(x, y, dec, label=legend, color=color)
        else:
            legend, d, color = tup
            x = [k.x for k in d]
            y = [k.y for k in d]
            plt.plot(x, y, label=legend, color=color)

    # Set log-log graph, using 2^x for x values
    plt.xscale("log")
    plt.yscale("log")

    axes = plt.gca()

    if ax:
        axes.set_xlim(ax[0])
        axes.set_ylim(ax[1])
    ax = (axes.get_xlim(), axes.get_ylim())

    plt.xlabel("Samples")
    plt.ylabel("Variance")
    plt.legend()
    fig.suptitle(title, x=0.55)
    fig.tight_layout()
    fig.subplots_adjust(top=0.92)

    plt.savefig(f"{fname}.pgf", bbox_inches='tight', pad_inches=0)
    plt.savefig(f"{fname}.pdf", bbox_inches='tight', pad_inches=0)

    # plt.show()
    return ax


def generate_graphs():
    """ Generate all graphs given structure input data
    """
    # A mapping of integrand "pretty" names to the actual folder names
    integrands = [
        ("Spheres", "bluespheres"),
        ("Cornell box", "cornell-box"),
    ]
    samplers = [
        ("Random", "random", False),
        ("Stratified", "stratified", False),
        ("Multi-jittered", "multijittered", True),
        ("CMJ2D", "cmj2d", True),
        ("(0,2)-sequence", "02sequence", False),
        ("OA(t=2)", "bushpp", True),
        ("Halton", "halton", False),
        # ("Sobol", "sobol", False),
    ]

    # matplotlib color codes
    # color_codes = ["b", "g", "r", "c", "m", "y", "k", "lavender"]
    color_codes = ["C7", "C0", "C1", "C2", "C3", "C4", "C5", "C6"]

    # the suffix that is applied to every variance data file
    prefix = "pbrt-eea-"
    suffix = "-mse-Pbrt-random.txt"

    # the root directory for the output graphs
    output_folder = "./eea_graphs/"
    input_folder = "./input_data/eea"

    # progress bar
    pbar_len = len(integrands) * len(samplers) + len(integrands)
    pbar = tqdm(total=pbar_len)

    # make graphs for each integrand
    for integrand in integrands:
        # get the input data from each sampler
        plot_data = list()

        # the best fit line data
        best_fit_lines = list()

        # Retrieve the graph data
        for i, sampler in enumerate(samplers):
            # TODO(afnan) make this part concurrent
            input_data = load_file(
                f"{input_folder}/{integrand[1]}/{sampler[1]}/{prefix}{sampler[1]}{suffix}",
                sampler[2])
            try:
                data, slope = best_fit_line(input_data)
                plot_data.append((sampler[0] + f", $({slope:.2f})$",
                                  input_data, "-", color_codes[i]))
                pbar.update(1)
            except TypeError:
                print(
                    f"WARNING: The input data for {sampler[0]}/{integrand[0]}"
                    " was bad and will not be plotted")
        output_fname = f"{output_folder}{integrand[1]}"
        ax = var_multi_plot(
            data=plot_data + best_fit_lines,
            fname=output_fname,
            title=integrand[0],
            ax=None)
        pbar.update(1)
    pbar.close()


def main() -> int:
    generate_graphs()
    return 0


if __name__ == "__main__":
    sys.exit(main())
