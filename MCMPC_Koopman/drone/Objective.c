#include <mex.h>

void mexFunction(int returnvalue, mxArray *plhs[], int argument, const mxArray* prhs[])
{
    int i = 0;
    double sum = 0;

    if(argument <= 0)
    {
        mexErrMsgTxt("引数がありません。");
    }

    if(returnvalue != 1)
    {
        mexErrMsgTxt("返値がありません。");
    }

    for(i = 0; i < argument; i++)
    {
        sum += (double)mxGetScalar(prhs[i]);
    }

    plhs[0] = mxCreateDoubleScalar(sum);
}
