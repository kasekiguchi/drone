#include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
//     if (nrhs != 2)
//     {
//         mexErrMsgIdAndTxt("example:nrhs", "One input argument required.");
//     }

    // 入力行列のポインタを取得
    double *inputMatrix1 = mxGetPr(prhs[0]);
    double *inputMatrix2 = mxGetPr(prhs[1]);
//     int numRows = mxGetM(prhs[0]);
//     int numCols = mxGetN(prhs[0]);

    // 行列の各要素を2倍する
    mxArray *outputMatrix = mxCreateDoubleMatrix(3, 3, mxREAL);
    double *outputData = mxGetPr(outputMatrix);

//     for (int i = 0; i < numRows * numCols; i++)
//     {
//         outputData[i] = inputMatrix1[i] * inputMatrix2[i];
//     }
    outputData[0] = inputMatrix1[0]*inputMatrix2[0];
    outputData[1] = inputMatrix1[1]*inputMatrix2[1];
    outputData[2] = inputMatrix1[2]*inputMatrix2[2];
    outputData[3] = inputMatrix1[3]*inputMatrix2[3];
    outputData[4] = inputMatrix1[4]*inputMatrix2[4];
    outputData[5] = inputMatrix1[5]*inputMatrix2[5];
    outputData[6] = inputMatrix1[6]*inputMatrix2[6];
    outputData[7] = inputMatrix1[7]*inputMatrix2[7];
    outputData[8] = inputMatrix1[8]*inputMatrix2[8];
    outputData[9] = inputMatrix1[9]*inputMatrix2[9];

    plhs[0] = outputMatrix;
}
