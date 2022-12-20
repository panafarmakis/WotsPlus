#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "Sha256.h"

#define w 16 
// 16 bytes input
#define len_1 32
#define len_2 3
#define len 35
#define N_BYTE 16

#define WOTS_HASH 0
#define WOTS_PK 1
#define TREE 2 
#define FORS_TREE 3
#define FORS_ROOTS 4 

typedef unsigned char BYTE ; 

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
    return n+m;
   
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
    return n+m;
}
void setHashAdrs(WOTS_P_HASH_ADRS *Addrs, int a)
{
    BYTE HashAdrs [4] ; 
    int i ;
    toByte(a,4,HashAdrs);
    for (i=0;i<4;i++)
    {
       Addrs->Hash_ADRS[i]=HashAdrs[i];
    }
}
void setChainAdrs(WOTS_P_HASH_ADRS *Addrs, int a)
{
    int i ;
    BYTE ChainAdrs [4];
    toByte(a,4,ChainAdrs);
      
    for (i=0;i<4;i++)
    {
        Addrs->Chain_ADRS[i]=ChainAdrs[i];
    }
}

void setKeyPairAddrs(WOTS_P_HASH_ADRS *Addrs, int a)
{
    int i ;
    BYTE KeyPairAddrs[4];
    toByte(a,4,KeyPairAddrs);
    for (i=0;i<4;i++)
    {
        Addrs->Key_Pair_ADRS[i]=KeyPairAddrs[i];
    }
}
void setTreeAddress(WOTS_P_HASH_ADRS *Addrs, int a)
{
    int i ;
    BYTE TreeAddrs[12];
    toByte(a,12,TreeAddrs);
    for (i=0;i<12;i++)
    {
       Addrs->Tree_ADRS[i]=TreeAddrs[i];
    }

}

void setType(WOTS_P_HASH_ADRS *Addrs, int a)
{
    int i ; 
    BYTE Type[4];
    toByte(a,4,Type);
    for (i=0;i<4;i++)
    {
       Addrs->Type[i]=Type[i];
    }
    // set the last three words to 0 (2.7.3)
    setKeyPairAddrs(Addrs,0);
    setChainAdrs(Addrs,0);
    setHashAdrs(Addrs,0);
}
int GetKeyPairAddrs(WOTS_P_HASH_ADRS Addrs)
{
    int i ; 
    int KeyPairAdrs = 0 ; 
    for (i=0;i<4;i++)
    {
        KeyPairAdrs=Addrs.Key_Pair_ADRS[i] + KeyPairAdrs<<8;
    }
    return KeyPairAdrs;
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
//YTwkwhkyJG3PMpDWlEvRuN0BppYASt3J

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


void chain (BYTE X[N_BYTE] , int startIndex, int steps , BYTE PKseed[N_BYTE], WOTS_P_HASH_ADRS adrs, BYTE tmpfinal[16])
{
    BYTE Z[22];
    int k;
    BYTE tmp[32];
    int a; 
    int j=64-N_BYTE;
    BYTE J[j];
    int i ; 
    for(i=0;i<16;i++)
    {
        tmpfinal[i]=X[i];
    }  
    for (k=1;k<=steps;k++)
    {
        //chain (X ,startIndex , steps-1, PKseed, adrs, tmpfinal) ;
        setHashAdrs(&adrs, startIndex+k-1);
        BYTE con[86+N_BYTE] ;
        int q;
        WOTS_P_ADRS_C adrcs;
        compression_ADRS(&adrs,&adrcs);
        toByte0(j,J);
        q=Concatenation(N_BYTE,j,PKseed,J,con);
        unRoll(adrcs,Z);
        q=Concatenation(q,22,con,Z,con);
        q=Concatenation(q,N_BYTE,con,tmpfinal,con);
        sha256(con,q,tmp);
            for (i=0;i<16;i++)
        {
            tmpfinal[i]=tmp[i];
        }   
        
    }

  }


//Wots+ public key generation
void Wots_PKgen(BYTE SKseed[N_BYTE], BYTE PKseed[N_BYTE], WOTS_P_HASH_ADRS adrs, BYTE pk[N_BYTE])
{   
    
    int a; 
    BYTE Z[22];
    int i;
    WOTS_P_HASH_ADRS wotspkADRS; 
    copy(&wotspkADRS,adrs);
    
    BYTE sk[32];    
    BYTE tmp[len][N_BYTE];
    BYTE tmpfinal[16];
    
    int q=0;
    BYTE con[N_BYTE+22] ;

    for (i=0;i<len;i++)
    {
        setChainAdrs(&adrs,i);
        setHashAdrs(&adrs,0);
        WOTS_P_ADRS_C adrcs;
        compression_ADRS(&adrs,&adrcs);
        unRoll(adrcs,Z);
        q=Concatenation(N_BYTE,22,SKseed,Z,con);
        sha256(con,q,sk);
        chain(sk,0,w-1,PKseed,adrs,tmp[i]);
    }
    setType(&wotspkADRS,WOTS_PK);
    setKeyPairAddrs(&wotspkADRS,GetKeyPairAddrs(adrs));
    
    
    int k;
    int z = 64 - N_BYTE;
    
    BYTE con2[N_BYTE+len*N_BYTE+22+z];  // N_BYTE->Pkseed , 16-> tmpfinal(output of chain),  22-> WotspkAddrs (compressed + unrolled), j-> zeros
    BYTE L[22];
    BYTE Zeros[z];
    toByte0(z,Zeros);

    WOTS_P_ADRS_C adrcs2;
    compression_ADRS(&wotspkADRS,&adrcs2);
    unRoll(adrcs2,L);

 
    int l ;
    int m ;
    BYTE copytmp[len*N_BYTE];
    for (l=0;l<len;l++)
    {
        for(m=0;m<N_BYTE;m++)
        {
            copytmp[N_BYTE*l+m]=tmp[l][m];
        }
    }
    k=Concatenation(N_BYTE,z,PKseed,Zeros,con2);
    k=Concatenation(k,22,con2,L,con2);
    k=Concatenation(k,len*N_BYTE,con2,copytmp,con2); 
   sha256(con2,k,pk);
}



// Sign a message using WOTS+ 
void Wots_sign(BYTE M[N_BYTE] , BYTE SKseed[N_BYTE], BYTE PKseed[N_BYTE], WOTS_P_HASH_ADRS adrs, BYTE sig[len][N_BYTE])
{
    int i ; 
    int a;
    
    int csum = 0; 
    int msg[len];
    BYTE con[38];
    base_w(M,N_BYTE,len_1,msg);
    for (i=0;i<len_1;i++)
    {
        csum= csum + w - 1-msg[i];
    }
    if (( (int) log2(w)) %8!=0)
    {
       csum=csum << (8- ((int) (len_2*log2(w))) % 8); 

    } 
    int len_2_bytes=ceil(((len_2*log2(w))/8));
    int msgout[len_2];
    BYTE Z[len_2_bytes];
    toByte(csum,len_2_bytes,Z);
    base_w(Z,len_2_bytes,len_2,msgout);
    ConcatenationINT(len_1,len_2,msg,msgout,msg);

    BYTE skfinal[16]; 
    BYTE sk[32];
    BYTE K[22];
   

    int t;

    for (i=0;i<len;i++)
    {
        
        setChainAdrs(&adrs,i);
        setHashAdrs(&adrs,0);
        WOTS_P_ADRS_C adrcs;
        compression_ADRS(&adrs,&adrcs);
        unRoll(adrcs,K);
        t=Concatenation(N_BYTE,22,SKseed,K,con);
        sha256(con,t,sk);
        
        
        for (a=0;a<N_BYTE;a++)
        {
            skfinal[a]=sk[a]; 
        } 
        chain(skfinal,0,msg[i],PKseed,adrs,sig[i]);  
    }
    for (i=0;i<len;i++)
    {
          for (a=0;a<N_BYTE;a++)
        {
            printf("%02x",sig[i][a]);
        }
    
    }
   

     

}


void wots_pkFromSig(BYTE sig[len][N_BYTE], BYTE M[N_BYTE] , BYTE PKseed[N_BYTE], WOTS_P_HASH_ADRS adrs, BYTE pk_sig[N_BYTE])
{
    int csum = 0 ; 
    int i ; 
    int a;
    WOTS_P_HASH_ADRS wotspkADRS; 
    copy(&wotspkADRS,adrs);
    int msg[len];
    base_w(M,N_BYTE,len_1,msg);
    BYTE tmp[len][N_BYTE];
    for (i=0;i<len_1;i++)
    {
        csum= csum + w - 1-msg[i];
    }
     if (( (int) log2(w)) %8!=0 )
    {
       csum=csum << (8- ((int) (len_2*log2(w))) % 8);
    }
    int len_2_bytes=ceil(((len_2*log2(w))/8));
    int msgout[len_2];
    BYTE Z[len_2_bytes];
    toByte(csum,len_2_bytes,Z);
    base_w(Z,len_2_bytes,len_2,msgout);
    ConcatenationINT(len_1,len_2,msg,msgout,msg);  
    for (i=0;i<len;i++)
    {
        
        setChainAdrs(&adrs,i);
        chain(sig[i],msg[i],w-1-msg[i],PKseed,adrs,tmp[i]);
    }
    setType(&wotspkADRS,WOTS_PK);
    setKeyPairAddrs(&wotspkADRS,GetKeyPairAddrs(adrs));
    int k;
    int z = 64 - N_BYTE;
    BYTE con2[N_BYTE+len*N_BYTE+22+z];  // N_BYTE->Pkseed , 16-> tmpfinal(output of chain),  22-> WotspkAddrs (compressed + unrolled), j-> zeros
    BYTE L[22];
    BYTE Zeros[z];
    toByte0(z,Zeros);
    WOTS_P_ADRS_C adrcs2;
    compression_ADRS(&wotspkADRS,&adrcs2);
    unRoll(adrcs2,L);
    int l ;
    int m ;     
    BYTE copytmp[len*N_BYTE];
    for (l=0;l<len;l++)
    {
        for(m=0;m<N_BYTE;m++)
        {
            copytmp[N_BYTE*l+m]=tmp[l][m];
        }
    }
    k=Concatenation(N_BYTE,z,PKseed,Zeros,con2);
    k=Concatenation(k,22,con2,L,con2);
    k=Concatenation(k,len*N_BYTE,con2,copytmp,con2);
   sha256(con2,k,pk_sig);
}


int main ()
{  
    int i ; 
    BYTE MSG[N_BYTE] ="YTwkwhkyJG3PMpDW";
    BYTE Pkseed[N_BYTE];
    BYTE Skseed[N_BYTE];
    BYTE pk[N_BYTE];
    BYTE pk_sig[N_BYTE];

    for (i=0;i<N_BYTE;i++)
    {
        Skseed[i]=0;
        Pkseed[i]=(BYTE)i;
    }
    
    struct WOTS_P_HASH_ADRS adrs = {.Layer_ADRS={0,0,0,0} , .Tree_ADRS= {0,0,0,0,0,0,0,0,0,0,0,0}, .Type={0,0,0,0}, .Key_Pair_ADRS ={0,0,0,0}, .Chain_ADRS= {0,0,0,0}, .Hash_ADRS={0,0,0,0} } ;

    BYTE signature[len][N_BYTE]; 
    Wots_sign(MSG,Skseed,Pkseed,adrs,signature);
    Wots_PKgen(Skseed,Pkseed,adrs,pk);
    printf("\n");
    printf("\n");
    wots_pkFromSig(signature,MSG,Pkseed,adrs,pk_sig);
   
    return 0 ; 
}