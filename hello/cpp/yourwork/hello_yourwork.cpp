#include <iostream>

using namespace std;

int main()
{
    int my_rank;

    // get my rank (serial code has just one process!)
    my_rank = 0;

    // print message
    cout << "Hello from PE " << my_rank << endl;

    // goodbye
    return 0;
}