#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 2)
    {
        mexErrMsgIdAndTxt("example:nrhs", "One input argument required.");
    }

    // 入力行列のポインタを取得
    double *inputMatrix1 = mxGetPr(prhs[0]);
    double *inputMatrix2 = mxGetPr(prhs[1]);
    int numRows = mxGetM(prhs[0]);
    int numCols = mxGetN(prhs[0]);

    // 行列の各要素を2倍する
    mxArray *outputMatrix = mxCreateDoubleMatrix(numRows, numCols, mxREAL);
    double *outputData = mxGetPr(outputMatrix);

    for (int i = 0; i < numRows * numCols; i++)
    {
        outputData[i] = inputMatrix1[i] * inputMatrix2[i];
    }

    plhs[0] = outputMatrix;
}
