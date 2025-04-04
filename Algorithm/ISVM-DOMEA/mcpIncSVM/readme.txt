mcpIncSVM - Incremental SVM Learning with multiclass support and probabilistic output


Description
===========

This MATLAB package implements the methods for incremental SVM learning[1], probabilistic output[2] and multiclass support[3]. It is based on the incremental SVM code by Christopher Diehl.

[1] Christopher Diehl and Gert Cauwenberghs. SVM incremental learning, adaptation and optimization. In Proceedings of the 2003 International Joint Conference on Neural Networks, pages 2685–2690, 2003
[2] Hsuan-Tien Lin, Chih-Jen Lin, and Ruby C. Weng. A note on Platt’s probabilistic outputs for support vector machines. Technical report, Department of Computer Science, National Taiwan University, 2003
[3] T.-F. Wu, C.-J. Lin, and R. C. Weng. Probability estimates for multi-class classification by pairwise coupling. Journal of Machine Learning Research, 5:975-1005, 2004

Installation and Hints
======================

Just add the mcpIncSVM Directory to your matlab paths.

The current "working"-SVM model is stored global to ensure high performance. Therefore only one model can be used at a time and make sure not to overwrite the variables mcp_model or model.
To load, save or switch between models use mcp_getModel and mcp_setModel.
Use mcp_svmtrain to train a new SVM from scratch (overwrites old model) and mcp_svmtrain_next to incrementally train the current SVM model.

Methods
=======

    mcp_getModel        returns SVM model
    mcp_setModel        set a new SVM model, overwrites current one
    mcp_svmgetWeights   return SVM weights for linear SVM and parameters A,B for probabilistic output
    mcp_svmpredict      predicts class label and probabilities for new sample
    mcp_svmtrain        train a new SVM model from scratch, overwrites current one
    mcp_svmtrain_next   incrementally train current SVM

ToDo
====

    - turn into object-oriented framework to get rid of global variables
    - add decremental learning and leave-one-out estimation
    - pertubations for regularisation and kernel parameters

License
=======

Copyright (C) 2006  Christopher P. Diehl
Copyright (C) 2011  Martin Spüler

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.