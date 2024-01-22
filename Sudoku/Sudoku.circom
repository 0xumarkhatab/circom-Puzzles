pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/comparators.circom";


/*
    Given a 4x4 sudoku board with array signal input "question" and "solution", check if the solution is correct.

    "question" is a 16 length array. Example: [0,4,0,0,0,0,1,0,0,0,0,3,2,0,0,0] == [0, 4, 0, 0]
                                                                                   [0, 0, 1, 0]
                                                                                   [0, 0, 0, 3]
                                                                                   [2, 0, 0, 0]

    "solution" is a 16 length array. Example: [1,4,3,2,3,2,1,4,4,1,2,3,2,3,4,1] == [1, 4, 3, 2]
                                                                                   [3, 2, 1, 4]
                                                                                   [4, 1, 2, 3]
                                                                                   [2, 3, 4, 1]

    "out" is the signal output of the circuit. "out" is 1 if the solution is correct, otherwise 0.                                                                               
*/


template Sudoku () {
    // Question Setup 
    signal input  question[16];
    signal input solution[16];
    signal output out;

    // Checking if the question is valid
    for(var v = 0; v < 16; v++){
        log(solution[v],question[v]);
        assert(question[v] == solution[v] || question[v] == 0);
    }
    
    var m = 0 ;
    component row1[4];
    for(var q = 0; q < 4; q++){
        row1[m] = IsEqual();
        row1[m].in[0]  <== question[q];
        row1[m].in[1] <== 0;
        m++;
    }
    3 === row1[3].out + row1[2].out + row1[1].out + row1[0].out;

    m = 0;
    component row2[4];
    for(var q = 4; q < 8; q++){
        row2[m] = IsEqual();
        row2[m].in[0]  <== question[q];
        row2[m].in[1] <== 0;
        m++;
    }
    3 === row2[3].out + row2[2].out + row2[1].out + row2[0].out; 

    m = 0;
    component row3[4];
    for(var q = 8; q < 12; q++){
        row3[m] = IsEqual();
        row3[m].in[0]  <== question[q];
        row3[m].in[1] <== 0;
        m++;
    }
    3 === row3[3].out + row3[2].out + row3[1].out + row3[0].out; 

    m = 0;
    component row4[4];
    for(var q = 12; q < 16; q++){
        row4[m] = IsEqual();
        row4[m].in[0]  <== question[q];
        row4[m].in[1] <== 0;
        m++;
    }
    3 === row4[3].out + row4[2].out + row4[1].out + row4[0].out; 

    // Write your solution from here.. Good Luck!
    var stopLoop=0;
    var matrix[4][4];

    // row uniqueness
    var isUnique=0; // not unqiue


    // check rows uniqueness

    for(var i=0;i<4;i=i+1){
        var row[4];
        row[0]=solution[i*4];
        row[1]=solution[i*4+1];
        row[2]=solution[i*4+2];
        row[3]=solution[i*4+3];

        isUnique <-- ( row[0]==row[1] ||  row[0]==row[2] || row[0]==row[3]) ? 0:1;

        if( isUnique == 0 ){
            out<==0;
            break;
        }
    }

    // check columns uniqueness
    
    for(var i=0;i<4;i=i+1){
        var col[4];
        col[0]=solution[i];
        col[1]=solution[i+4*1];
        col[2]=solution[i+4*2];
        col[3]=solution[i+4*3];
        
//         [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
//          0                 5             9 13
// i=0       i  = 0 ,            i+*4*1 = 4  , i+4*2 = 8 , i+4*3 = 12 // 0  4 8 12 
// i=1       i  = 1 ,                 1+4=5 

        isUnique <-- ( col[0]==col[1] ||  col[0]==col[2] || col[0]==col[3]) ? 0:1;

        if( isUnique == 0 ){
            out<==0;
            break;
        }
    }
    
    // check 2x2 matrices
    // check vertically -> horizontally
   for(var j=0;j<4-1;j=j+1){
        var i = j*4;
        var submatrix1[4];
        submatrix1[0]=solution[i];
        submatrix1[1]=solution[i+1];
        submatrix1[2]=solution[i+4*1];
        submatrix1[3]=solution[i+4*1+1];

        i=i+1;
        var submatrix2[4];
        submatrix2[0]=solution[i];
        submatrix2[1]=solution[i+1];
        submatrix2[2]=solution[i+4*1];
        submatrix2[3]=solution[i+4*1+1];

        i=i+1;
        var submatrix3[4];
        submatrix3[0]=solution[i];
        submatrix3[1]=solution[i+1];
        submatrix3[2]=solution[i+4*1];
        submatrix3[3]=solution[i+4*1+1];


// [1 2 3 4 ]
// [1 2 3 4 ]
// [1 2 3 4 ]
// [1 2 3 4 ]

//         [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16]
//          0                 5             9 13
// i=0       i  = 0 ,            i+*4*1 = 4  , i+4*2 = 8 , i+4*3 = 12 // 0  4 8 12 
// i=1       i  = 1 ,                 1+4=5 

        isUnique <-- ( submatrix1[0]==submatrix1[1] ||  submatrix1[0]==submatrix1[2] || submatrix1[0]==submatrix1[3]) ? 0:1;
        out<== isUnique==0?0:1;
        if( isUnique == 0 ){ 
            break;
        }

        isUnique <-- ( submatrix2[0]==submatrix2[1] ||  submatrix2[0]==submatrix2[2] || submatrix2[0]==submatrix2[3]) ? 0:1;
        out<== isUnique==0?0:1;
        if( isUnique == 0 ){ 
            break;
        }

        isUnique <-- ( submatrix3[0]==submatrix3[1] ||  submatrix3[0]==submatrix3[2] || submatrix3[0]==submatrix3[3]) ? 0:1;
        out<== isUnique==0?0:1;

        if( isUnique == 0 ){ 
            break;
        }

    }
    if( isUnique==0){       
    }
    else{
            out <-- 1;

    }
    log(out);
   
}


component main = Sudoku();

