#include <stdio.h>
#include <math.h>
#include <stdlib.h>

typedef unsigned char BYTE ; 
#define w 16 
typedef struct WOTS_P_HASH_ADRS
{    
    BYTE Layer_ADRS[4];
    BYTE Tree_ADRS[12];
    BYTE Type[4];
    BYTE Key_Pair_ADRS[4];
    BYTE Chain_ADRS[4];
    BYTE Hash_ADRS[4];
}  WOTS_P_HASH_ADRS; // WOTS_HASH // TYPE 0 ; 
typedef struct WOTS_P_ADRS_C
{ 
    BYTE Layer_ADRS_C;    
    BYTE Tree_ADRS_C[8];
    BYTE Type_C;
    BYTE Key_Pair_ADRS_C[4];
    BYTE Chain_ADRS_C[4];
    BYTE Hash_ADRS_C[4];   
}  WOTS_P_ADRS_C; //WOTS_HASH_COMPRESSED 



void toByte(unsigned long long int N,int outlen, BYTE Y[outlen])
{
    int i ; 
    
    for (i=outlen-1;i>=0;i--)
    {
        Y[i]=(BYTE)(N & 0xff);
        N=N>>8;   

    }   
}
void toByte0(int N, BYTE X[N] )
{
    int i ;   
    for (i=0;i<N;i++)
    {
        X[i]=0;
    }
}
int Concatenation (int n, int m , BYTE X[n] , BYTE Y[m], BYTE Z[n+m] )
{
  
    int i ; 
    for (i=0; i<n; i++)
    {
        Z[i]=X[i];
    }

    for (i=0;i<m;i++)
    {
       Z[n+i]=Y[i];
    }
    //printf("%d ", m+n);
    return n+m; // max = 646 ; 
   
}
int ConcatenationINT (int n, int m , int X[n] , int Y[m], int Z[n+m])
{
  
    int i ; 
    for (i=0; i<n; i++)
    {
        Z[i]=X[i];
    }

    for (i=0;i<m;i++)
    {
       Z[n+i]=Y[i];
    }
    //printf("%d",m+n); 
    return n+m; // max = 35 ; 
}

void unRoll(WOTS_P_ADRS_C Addr, BYTE Z[22])
{

    int x ; 
    int i; 
    //BYTE *Z=(BYTE*)malloc(sizeof(BYTE)*22);
    
    x=Concatenation(1,8,&Addr.Layer_ADRS_C,Addr.Tree_ADRS_C,Z);
    
    x=Concatenation(x,1,Z,&Addr.Type_C,Z);
    
    x=Concatenation(x,4,Z,&Addr.Key_Pair_ADRS_C,Z);
    
    x=Concatenation(x,4,Z,&Addr.Chain_ADRS_C,Z);
    x=Concatenation(x,4,Z,&Addr.Hash_ADRS_C,Z);

}

void compression_ADRS (WOTS_P_HASH_ADRS *Addrs ,WOTS_P_ADRS_C *Addrc)
{
    int i ; 
    Addrc->Layer_ADRS_C=Addrs->Layer_ADRS[3];
 
    for (i=0; i<8 ; i++)
    {
        Addrc->Tree_ADRS_C[i]=Addrs->Tree_ADRS[i+4];
       
    } 
    Addrc->Type_C=Addrs->Type[3]; 
    for (i=0;i<4;i++)
    {
        Addrc->Key_Pair_ADRS_C[i]=Addrs->Key_Pair_ADRS[i];
        Addrc->Chain_ADRS_C[i]=Addrs->Chain_ADRS[i];    
        Addrc->Hash_ADRS_C[i]=Addrs->Hash_ADRS[i];
    }
}

void base_w (BYTE *input , int len_x, int out_len, int *output)
{
    int in=0;
    int out=0;
    int total=0;
    int bits = 0;
    int cst = log2(w);  
    int c = 0 ;
    for (c=0;c<out_len;c++)
    {
        if (bits==0)
        {
            total = input[in];
            in++;
            bits+=8;       
        }
        bits -= cst; 
        output[out]=(total>>bits)&(w-1);
        out++;
    }
}
  
void copy(WOTS_P_HASH_ADRS *wotspkADRS, WOTS_P_HASH_ADRS adrs)
{
    int i ;
    for (i=0; i<4 ;i++)
    {
        wotspkADRS->Chain_ADRS[i]=adrs.Chain_ADRS[i];
        wotspkADRS->Layer_ADRS[i]=adrs.Layer_ADRS[i];
        wotspkADRS->Hash_ADRS[i]=adrs.Hash_ADRS[i];
        wotspkADRS->Key_Pair_ADRS[i]=adrs.Key_Pair_ADRS[i];       
        wotspkADRS->Type[i]=adrs.Type[i];
    }
    for (i=0;i<12;i++)
    {
        wotspkADRS->Tree_ADRS[i]=adrs.Tree_ADRS[i];
    }

}
void PrintAdrs(WOTS_P_HASH_ADRS adrs)
{
    int i; 
    for(i=0;i<4;i++)
    {
        printf("%d ", adrs.Layer_ADRS[i]);
    }
    printf("\n");
    for (i=0;i<12;i++)
    {
        printf("%d ", adrs.Tree_ADRS[i]);

    }
    printf("\n");
    for (i=0;i<4;i++)
    {
        printf("%d ", adrs.Type[i]);
    }
    printf("\n");
    for(i=0;i<4;i++)
    {
        printf("%d " , adrs.Key_Pair_ADRS[i] );
    }
    printf("\n");
    for(i=0;i<4;i++)
    {
        printf("%d ", adrs.Chain_ADRS[i]);
    }
    printf("\n");
    for(i=0;i<4;i++)
    {
        printf("%d ", adrs.Hash_ADRS[i]);
    }
}
 //main function to test base_w
int main_test_base_w ()
{
    BYTE input[] = {0x12,0x34,0x56};
    int out_len = 5; 
    int output[5];
    int i ; 
    for (i=0;i<out_len;i++)
    {
        printf("%d\n",output[i]);
    }
}
