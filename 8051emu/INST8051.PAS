{**}
{*  Modul wykonawczyˆ do mikroprocesora 8051 (C) Copyright by Tomasz Jaworski *}
{*  1999-2001*}
{**}
unit inst8051;
{{$A+,B-,D+,E+,F+,G+,I+,L+,N+,O+,P+,Q-,R-,S+,T-,V+,X+,Y+}
{{$M 65520,0,655360}
interface
uses Crt, Dos, Procki, Zmienne, Nazwy, Stale, Symb;

const MaxNazwaInstrukcji = 10;
      MaxBuforInstr      = 8;
      OdstepInstrArg     = ' ';
      OdstepArgArg       = ' ';
      ZnakNegacjiBitu    = '/';

Type TTypParametru = (tprNieznany, tprCode11, tprCode16, tprACC,   tprRi,       tprRn,
                      tprRamAddr,  tprBit,    tprCode8,  tprData8, tprPtrADPTR,
                      tprPtrAPC,   tprDPTR,   tprData16, tprC,     tprAB,       tprNegBit,
                      tprPtrDPTR);

     TBuforInstr = array[1..MaxBuforInstr] of byte;
     TProckaDAsm = procedure(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
     TProckaRUN = procedure(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);

     TNazwaInstrukcji = array[1..MaxNazwaInstrukcji+1] of char;

     TInstrukcja = record
         Nazwa:TNazwaInstrukcji;
         Cyk:Byte;
         OpKod:Byte;
         Bajtow:Byte;
         DASM:TProckaDAsm;
         RUN:TProckaRun;
     end;

     TWpisWTablicyInstrukcji = record
       Nazwa:TNazwaInstrukcji;
       OpKod:byte;
       IloscPar:byte;
       par:array[1..3] of TTypParametru;
       MoznaZaufac:Boolean;
     end;

procedure RUN_D(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure DASM_D(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_ND(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure R_ND(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
{--------------------------------------------------------------}
procedure D_NOP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_LCALL_LJMP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_RR_RL_RRC_RLC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_INC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_DEC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_RET_RETI(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_ADD(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_ADDC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_SUBB(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_ORL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_ANL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_XRL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_SWAP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_SETB(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_CPL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_CLR(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_AJMP_ACALL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_MOVC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_DIV_MUL_DA(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_XCH(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_PUSH_POP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_SJMP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_DJNZ(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_MOVX(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_XCHD(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_CJNE(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_JB_JNB_JBC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_JC_JNC_JZ_JNZ(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_JMP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
procedure D_MOV(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
{**************************************************************************}
procedure R_NOP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_ADD(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_MOV(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_CLR(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_CPL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_SWAP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_DA(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_SETB(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_PUSH_POP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_DEC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_INC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_ADDC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_RR_RL_RRC_RLC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_LCALL_LJMP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_RET_RETI(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_AJMP_ACALL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_JB_JNB_JBC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_JC_JNC_JZ_JNZ(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_DIV_MUL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_ORL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_XRL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_ANL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_MOVC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_JMP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_SJMP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_XCH(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_XCHD(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_DJNZ(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_CJNE(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
procedure R_SUBB(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);

const Instrukcje : array[0..255] of TInstrukcja = (
(Nazwa:'NOP';   Cyk:1;  OpKod:$00;      Bajtow:1;       Dasm:D_NOP;             Run:R_NOP),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$01;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'LJMP';  Cyk:2;  OpKod:$02;      Bajtow:3;       Dasm:D_LCALL_LJMP;      Run:R_LCALL_LJMP),
(Nazwa:'RR';    Cyk:1;  OpKod:$03;      Bajtow:1;       Dasm:D_RR_RL_RRC_RLC;   Run:R_RR_RL_RRC_RLC),
(Nazwa:'INC';   Cyk:1;  OpKod:$04;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$05;      Bajtow:2;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$06;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$07;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$08;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$09;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$0A;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$0B;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$0C;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$0D;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$0E;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'INC';   Cyk:1;  OpKod:$0F;      Bajtow:1;       Dasm:D_INC;             Run:R_inc),
(Nazwa:'JBC';   Cyk:2;  OpKod:$10;      Bajtow:3;       Dasm:D_JB_JNB_JBC;      Run:R_JB_JNB_JBC),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$11;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'LCALL'; Cyk:2;  OpKod:$12;      Bajtow:3;       Dasm:D_LCALL_LJMP;      Run:R_LCALL_LJMP),
(Nazwa:'RRC';   Cyk:1;  OpKod:$13;      Bajtow:1;       Dasm:D_RR_RL_RRC_RLC;   Run:R_RR_RL_RRC_RLC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$14;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$15;      Bajtow:2;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$16;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$17;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$18;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$19;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$1A;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$1B;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$1C;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$1D;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$1E;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'DEC';   Cyk:1;  OpKod:$1F;      Bajtow:1;       Dasm:D_DEC;             Run:R_DEC),
(Nazwa:'JB';    Cyk:2;  OpKod:$20;      Bajtow:3;       Dasm:D_JB_JNB_JBC;      Run:R_JB_JNB_JBC),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$21;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'RET';   Cyk:2;  OpKod:$22;      Bajtow:1;       Dasm:D_RET_RETI;        Run:R_RET_RETI),
(Nazwa:'RL';    Cyk:1;  OpKod:$23;      Bajtow:1;       Dasm:D_RR_RL_RRC_RLC;   Run:R_RR_RL_RRC_RLC),
(Nazwa:'ADD';   Cyk:1;  OpKod:$24;      Bajtow:2;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$25;      Bajtow:2;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$26;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$27;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$28;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$29;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$2A;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$2B;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$2C;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$2D;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$2E;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'ADD';   Cyk:1;  OpKod:$2F;      Bajtow:1;       Dasm:D_ADD;             Run:R_ADD),
(Nazwa:'JNB';   Cyk:2;  OpKod:$30;      Bajtow:3;       Dasm:D_JB_JNB_JBC;      Run:R_JB_JNB_JBC),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$31;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'RETI';  Cyk:2;  OpKod:$32;      Bajtow:1;       Dasm:D_RET_RETI;        Run:R_RET_RETI),
(Nazwa:'RLC';   Cyk:1;  OpKod:$33;      Bajtow:1;       Dasm:D_RR_RL_RRC_RLC;   Run:R_RR_RL_RRC_RLC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$34;      Bajtow:2;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$35;      Bajtow:2;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$36;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$37;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$38;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$39;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$3A;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$3B;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$3C;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$3D;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$3E;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'ADDC';  Cyk:1;  OpKod:$3F;      Bajtow:1;       Dasm:D_ADDC;            Run:R_ADDC),
(Nazwa:'JC';    Cyk:2;  OpKod:$40;      Bajtow:2;       Dasm:D_JC_JNC_JZ_JNZ;   Run:R_JC_JNC_JZ_JNZ),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$41;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'ORL';   Cyk:2;  OpKod:$42;      Bajtow:2;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:2;  OpKod:$43;      Bajtow:3;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$44;      Bajtow:2;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$45;      Bajtow:2;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$46;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$47;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$48;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$49;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$4A;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$4B;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$4C;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$4D;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$4E;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'ORL';   Cyk:1;  OpKod:$4F;      Bajtow:1;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'JNC';   Cyk:2;  OpKod:$50;      Bajtow:2;       Dasm:D_JC_JNC_JZ_JNZ;   Run:R_JC_JNC_JZ_JNZ),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$51;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$52;      Bajtow:2;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:2;  OpKod:$53;      Bajtow:3;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$54;      Bajtow:2;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$55;      Bajtow:2;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$56;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$57;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$58;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$59;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$5A;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$5B;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$5C;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$5D;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$5E;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ANL';   Cyk:1;  OpKod:$5F;      Bajtow:1;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'JZ';    Cyk:2;  OpKod:$60;      Bajtow:2;       Dasm:D_JC_JNC_JZ_JNZ;   Run:R_JC_JNC_JZ_JNZ),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$61;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$62;      Bajtow:2;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:2;  OpKod:$63;      Bajtow:3;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$64;      Bajtow:2;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$65;      Bajtow:2;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$66;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$67;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$68;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$69;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$6A;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$6B;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$6C;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$6D;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$6E;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'XRL';   Cyk:1;  OpKod:$6F;      Bajtow:1;       Dasm:D_XRL;             Run:R_XRL),
(Nazwa:'JNZ';   Cyk:2;  OpKod:$70;      Bajtow:2;       Dasm:D_JC_JNC_JZ_JNZ;   Run:R_JC_JNC_JZ_JNZ),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$71;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'ORL';   Cyk:2;  OpKod:$72;      Bajtow:2;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'JMP';   Cyk:2;  OpKod:$73;      Bajtow:1;       Dasm:D_JMP;             Run:R_JMP),
(Nazwa:'MOV';   Cyk:1;  OpKod:$74;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$75;      Bajtow:3;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$76;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$77;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$78;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$79;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$7A;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$7B;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$7C;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$7D;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$7E;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$7F;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'SJMP';  Cyk:2;  OpKod:$80;      Bajtow:2;       Dasm:D_SJMP;            Run:R_SJMP),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$81;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'ANL';   Cyk:2;  OpKod:$82;      Bajtow:2;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'MOVC';  Cyk:2;  OpKod:$83;      Bajtow:1;       Dasm:D_MOVC;            Run:R_MOVC),
(Nazwa:'DIV';   Cyk:4;  OpKod:$84;      Bajtow:1;       Dasm:D_DIV_MUL_DA;      Run:R_div_mul),
(Nazwa:'MOV';   Cyk:2;  OpKod:$85;      Bajtow:3;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$86;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$87;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$88;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$89;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$8A;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$8B;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$8C;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$8D;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$8E;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$8F;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$90;      Bajtow:3;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$91;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'MOV';   Cyk:2;  OpKod:$92;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOVC';  Cyk:2;  OpKod:$93;      Bajtow:1;       Dasm:D_MOVC;            Run:R_MOVC),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$94;      Bajtow:2;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$95;      Bajtow:2;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$96;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$97;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$98;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$99;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$9A;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$9B;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$9C;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$9D;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$9E;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'SUBB';  Cyk:1;  OpKod:$9F;      Bajtow:1;       Dasm:D_SUBB;            Run:R_SUBB),
(Nazwa:'ORL';   Cyk:2;  OpKod:$A0;      Bajtow:2;       Dasm:D_ORL;             Run:R_ORL),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$A1;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'MOV';   Cyk:1;  OpKod:$A2;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'INC';   Cyk:2;  OpKod:$A3;      Bajtow:1;       Dasm:D_INC;             Run:r_inc),
(Nazwa:'MUL';   Cyk:4;  OpKod:$A4;      Bajtow:1;       Dasm:D_DIV_MUL_DA;      Run:R_div_mul),
(Nazwa:'?????'; Cyk:1;  OpKod:$A5;      Bajtow:1;       Dasm:D_ND;              Run:R_ND),
(Nazwa:'MOV';   Cyk:2;  OpKod:$A6;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$A7;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$A8;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$A9;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$AA;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$AB;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$AC;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$AD;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$AE;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:2;  OpKod:$AF;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'ANL';   Cyk:2;  OpKod:$B0;      Bajtow:2;       Dasm:D_ANL;             Run:R_ANL),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$B1;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'CPL';   Cyk:1;  OpKod:$B2;      Bajtow:2;       Dasm:D_CPL;             Run:R_CPL),
(Nazwa:'CPL';   Cyk:1;  OpKod:$B3;      Bajtow:1;       Dasm:D_CPL;             Run:R_CPL),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$B4;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$B5;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$B6;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$B7;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$B8;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$B9;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$BA;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$BB;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$BC;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$BD;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$BE;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'CJNE';  Cyk:2;  OpKod:$BF;      Bajtow:3;       Dasm:D_CJNE;            Run:R_CJNE),
(Nazwa:'PUSH';  Cyk:2;  OpKod:$C0;      Bajtow:2;       Dasm:D_PUSH_POP;        Run:R_PUSH_POP),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$C1;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'CLR';   Cyk:1;  OpKod:$C2;      Bajtow:2;       Dasm:D_CLR;             Run:R_ClR),
(Nazwa:'CLR';   Cyk:1;  OpKod:$C3;      Bajtow:1;       Dasm:D_CLR;             Run:R_CLR),
(Nazwa:'SWAP';  Cyk:1;  OpKod:$C4;      Bajtow:1;       Dasm:D_SWAP;            Run:R_SWAP),
(Nazwa:'XCH';   Cyk:1;  OpKod:$C5;      Bajtow:2;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$C6;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$C7;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$C8;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$C9;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$CA;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$CB;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$CC;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$CD;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$CE;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'XCH';   Cyk:1;  OpKod:$CF;      Bajtow:1;       Dasm:D_xch;             Run:R_XCH),
(Nazwa:'POP';   Cyk:2;  OpKod:$D0;      Bajtow:2;       Dasm:D_PUSH_POP;        Run:R_PUSH_POP),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$D1;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'SETB';  Cyk:1;  OpKod:$D2;      Bajtow:2;       Dasm:D_SETB;            Run:R_SetB),
(Nazwa:'SETB';  Cyk:1;  OpKod:$D3;      Bajtow:1;       Dasm:D_SETB;            Run:R_SetB),
(Nazwa:'DA';    Cyk:1;  OpKod:$D4;      Bajtow:1;       Dasm:d_div_mul_da;      Run:r_da),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$D5;      Bajtow:3;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'XCHD';  Cyk:1;  OpKod:$D6;      Bajtow:1;       Dasm:d_xchd;            Run:R_XCHD),
(Nazwa:'XCHD';  Cyk:1;  OpKod:$D7;      Bajtow:1;       Dasm:d_xchd;            Run:R_XCHD),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$D8;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$D9;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$DA;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$DB;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$DC;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$DD;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$DE;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'DJNZ';  Cyk:2;  OpKod:$DF;      Bajtow:2;       Dasm:D_DJNZ;            Run:R_DJNZ),
(Nazwa:'MOVX';  Cyk:2;  OpKod:$E0;      Bajtow:1;       Dasm:D_MOVX;            Run:R_ND),
(Nazwa:'AJMP';  Cyk:2;  OpKod:$E1;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'MOVX';  Cyk:2;  OpKod:$E2;      Bajtow:1;       Dasm:D_MOVX;            Run:R_ND),
(Nazwa:'MOVX';  Cyk:2;  OpKod:$E3;      Bajtow:1;       Dasm:D_MOVX;            Run:R_ND),
(Nazwa:'CLR';   Cyk:1;  OpKod:$E4;      Bajtow:1;       Dasm:D_CLR;             Run:R_clr),
(Nazwa:'MOV';   Cyk:1;  OpKod:$E5;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$E6;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$E7;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$E8;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$E9;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$EA;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$EB;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$EC;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$ED;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$EE;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$EF;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOVX';  Cyk:2;  OpKod:$F0;      Bajtow:1;       Dasm:D_MOVX;            Run:R_ND),
(Nazwa:'ACALL'; Cyk:2;  OpKod:$F1;      Bajtow:2;       Dasm:D_AJMP_ACALL;      Run:R_AJMP_ACALL),
(Nazwa:'MOVX';  Cyk:2;  OpKod:$F2;      Bajtow:1;       Dasm:D_MOVX;            Run:R_ND),
(Nazwa:'MOVX';  Cyk:2;  OpKod:$F3;      Bajtow:1;       Dasm:D_MOVX;            Run:R_ND),
(Nazwa:'CPL';   Cyk:1;  OpKod:$F4;      Bajtow:1;       Dasm:D_CPL;             Run:R_cpl),
(Nazwa:'MOV';   Cyk:1;  OpKod:$F5;      Bajtow:2;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$F6;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$F7;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$F8;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$F9;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$FA;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$FB;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$FC;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$FD;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$FE;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV),
(Nazwa:'MOV';   Cyk:1;  OpKod:$FF;      Bajtow:1;       Dasm:D_MOV;             Run:R_MOV));

{var NaglaZmianaPC:Boolean;}

implementation


function isBitOn(kod,bit:byte):boolean;
begin
     isBitOn := ((kod shr bit) and 1) = 1
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure setBitOn (var kod:byte;bit:byte);
begin
asm;
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
     nop
end;
     kod := kod or (1 shl bit)
end;
{;þþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþþ}
procedure setBitOff (var kod:byte;bit:byte);
begin
     kod := kod and (not (1 shl bit))
end;


{********** procki dummy**************}
procedure DASM_D(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
end;
procedure RUN_D(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
end;

procedure D_ND(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := 'Nie dostepna!';
end;
procedure R_ND(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
end;


{**************************************************************************}
{**************************************************************************}
{**************************************************************************}
{********************* PROCEDURY DEASSEMBLUJ¤CE ***************************}
{**************************************************************************}
{**************************************************************************}
{**************************************************************************}
procedure D_NOP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin Instr := 'NOP'; end;

procedure D_LCALL_LJMP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var addr16:Word;
begin
     Instr := '';
     Addr16 := Swap(Word(Addr(Bufor[2])^));
     if Addr16 = Pozycja then
     begin
          case OpKod of
           $12: Instr := 'LCALL'+OdstepInstrArg+'$';
           $02: Instr := 'LJMP'+OdstepInstrArg+'$';
          end; {case}
     end else
     begin
          case OpKod of
           $12: Instr := 'LCALL'+OdstepInstrArg+{Dec2HexWH(Addr16)}ZnajdzSymbolROM(addr16);
           $02: Instr := 'LJMP'+OdstepInstrArg+{Dec2HexWH(Addr16)}ZnajdzSymbolROM(addr16);
          end; {case}
     end;
end;

procedure D_RR_RL_RRC_RLC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
     case OpKod of
      $23: Instr := 'RL'+OdstepInstrArg+'A';
      $33: Instr := 'RLC'+OdstepInstrArg+'A';
      $03: Instr := 'RR'+OdstepInstrArg+'A';
      $13: Instr := 'RRC'+OdstepInstrArg+'A';
     end; {case}
end;

procedure D_INC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var n:string;
begin
     Instr := '';
     case OpKod of
      $04: Instr := 'INC'+OdstepInstrArg+'A';
      $05: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'INC'+OdstepInstrArg+n;
           end;
      $06: Instr := 'INC'+OdstepInstrArg+'@R0';
      $07: Instr := 'INC'+OdstepInstrArg+'@R1';
      $08: Instr := 'INC'+OdstepInstrArg+'R0';
      $09: Instr := 'INC'+OdstepInstrArg+'R1';
      $0a: Instr := 'INC'+OdstepInstrArg+'R2';
      $0b: Instr := 'INC'+OdstepInstrArg+'R3';
      $0c: Instr := 'INC'+OdstepInstrArg+'R4';
      $0d: Instr := 'INC'+OdstepInstrArg+'R5';
      $0e: Instr := 'INC'+OdstepInstrArg+'R6';
      $0f: Instr := 'INC'+OdstepInstrArg+'R7';
      $A3: Instr := 'INC'+OdstepInstrArg+'DPTR';
     end; {case}
end;

procedure D_DEC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var n:string;
begin
     Instr := '';
     case OpKod of
      $14: Instr := 'DEC'+OdstepInstrArg+'A';
      $15: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'DEC'+OdstepInstrArg+n;
           end;
      $16: Instr := 'DEC'+OdstepInstrArg+'@R0';
      $17: Instr := 'DEC'+OdstepInstrArg+'@R1';
      $18: Instr := 'DEC'+OdstepInstrArg+'R0';
      $19: Instr := 'DEC'+OdstepInstrArg+'R1';
      $1a: Instr := 'DEC'+OdstepInstrArg+'R2';
      $1b: Instr := 'DEC'+OdstepInstrArg+'R3';
      $1c: Instr := 'DEC'+OdstepInstrArg+'R4';
      $1d: Instr := 'DEC'+OdstepInstrArg+'R5';
      $1e: Instr := 'DEC'+OdstepInstrArg+'R6';
      $1f: Instr := 'DEC'+OdstepInstrArg+'R7';
     end; {case}
end;

procedure D_RET_RETI(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
     case OpKod of
      $22: Instr := 'RET';
      $32: Instr := 'RETI';
     end; {case}
end;

procedure D_ADD(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    n:string;
begin
     Instr := '';
     case OpKod of
      $24: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $25: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $26: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $27: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $28: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $29: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $2A: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $2B: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $2C: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $2D: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $2E: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $2F: Instr := 'ADD'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
     end; {case}
end;

procedure D_ADDC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    n:string;
begin
     Instr := '';
     case OpKod of
      $34: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $35: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $36: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $37: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $38: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $39: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $3A: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $3B: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $3C: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $3D: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $3E: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $3F: Instr := 'ADDC'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
     end; {case}
end;

procedure D_SUBB(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    n:string;
begin
     Instr := '';
     case OpKod of
      $94: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $95: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $96: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $97: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $98: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $99: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $9A: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $9B: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $9C: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $9D: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $9E: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $9F: Instr := 'SUBB'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
     end; {case}
end;

procedure D_ORL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    N:String;
begin
     Instr := '';
     case OpKod of
      $42: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ORL'+OdstepInstrArg+n+','+OdstepArgArg+'A';
           end;
      $43: begin
                data := Bufor[3];
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ORL'+OdstepInstrArg+n+','+OdstepArgArg+'#'+Dec2HexBH(Data);
           end;
      $44: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $45: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $46: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $47: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $48: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $49: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $4a: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $4b: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $4c: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $4d: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $4e: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $4f: Instr := 'ORL'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
      $72: begin
                DajNazweBitu(Bufor[2], n, True);
                Instr := 'ORL'+OdstepInstrArg+'C,'+OdstepArgArg+N;
           end;
      $A0: begin
                DajNazweBitu(Bufor[2], n, True);
                Instr := 'ORL'+OdstepInstrArg+'C,'+OdstepArgArg+ZnakNegacjiBitu+N;
           end;
     end; {case}
end;

procedure D_XRL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    N:String;
begin
     Instr := '';
     case OpKod of
      $62: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'XRL'+OdstepInstrArg+n+','+OdstepArgArg+'A';
           end;
      $63: begin
                data := Bufor[3];
                DajNazweAdresu(Bufor[2],n);
                Instr := 'XRL'+OdstepInstrArg+n+','+OdstepArgArg+'#'+Dec2HexBH(Data);
           end;
      $64: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $65: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $66: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $67: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $68: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $69: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $6a: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $6b: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $6c: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $6d: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $6e: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $6f: Instr := 'XRL'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
     end; {case}
end;

procedure D_ANL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    N:String;
begin
     Instr := '';
     case OpKod of
      $52: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ANL'+OdstepInstrArg+n+','+OdstepArgArg+'A';
           end;
      $53: begin
                data := Bufor[3];
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ANL'+OdstepInstrArg+n+','+OdstepArgArg+'#'+Dec2HexBH(Data);
           end;
      $54: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $55: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $56: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $57: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $58: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $59: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $5a: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $5b: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $5c: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $5d: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $5e: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $5f: Instr := 'ANL'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
      $82: begin
                DajNazweBitu(Bufor[2], n, True);
                Instr := 'ANL'+OdstepInstrArg+'C,'+OdstepArgArg+N;
           end;
      $b0: begin
                DajNazweBitu(Bufor[2], n, True);
                Instr := 'ANL'+OdstepInstrArg+'C,'+OdstepArgArg+ZnakNegacjiBitu+N;
           end;
     end; {case}
end;

procedure D_SWAP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := 'SWAP'+OdstepInstrArg+'A';
end;
procedure D_SETB(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Nazwa:String;
begin
     Instr := '';
     case OpKod of
      $D2: begin
                DajNazweBitu(Bufor[2], nazwa, True);
                Instr := 'SETB'+OdstepInstrArg+Nazwa;
           end;
      $D3: Instr := 'SETB'+OdstepInstrArg+'C';
     end; {case}
end;

procedure D_CLR(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Nazwa:String;
begin
     Instr := '';
     case OpKod of
      $C2: begin
                DajNazweBitu(Bufor[2], nazwa, True);
                Instr := 'CLR'+OdstepInstrArg+Nazwa;
           end;
      $C3: Instr := 'CLR'+OdstepInstrArg+'C';
      $E4: Instr := 'CLR'+OdstepInstrArg+'A';
     end; {case}
end;

procedure D_CPL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Nazwa:String;
begin
     Instr := '';
     case OpKod of
      $B2: begin
                DajNazweBitu(Bufor[2], nazwa, True);
                Instr := 'CPL'+OdstepInstrArg+Nazwa;
           end;
      $B3: Instr := 'CPL'+OdstepInstrArg+'C';
      $F4: Instr := 'CPL'+OdstepInstrArg+'A';
     end; {case}
end;

procedure D_AJMP_ACALL(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var addrb:byte;
    addr:word;
begin
     Instr := '';
     case OpKod of
      $01,$21,$41,$61,$81,$A1,$C1,$E1 :
           begin
                addrb := OpKod and $E0;
                addrb := addrb shr 5;
                addr := bufor[2];
                addr := addr or (addrb shl 8);
                if Addr = Pozycja
                   then Instr := 'AJMP'+OdstepInstrArg+'$'
                   else Instr := 'AJMP'+OdstepInstrArg+ZnajdzSymbolROM(addr);
           end;
      $11,$31,$51,$71,$91,$b1,$d1,$f1 :
           begin
                addrb := OpKod and $E0;
                addrb := addrb shr 5;
                addr := bufor[2];
                addr := addr or (addrb shl 8);
                if Addr = Pozycja
                   then Instr := 'ACALL'+OdstepInstrArg+'$'
                   else Instr := 'ACALL'+OdstepInstrArg+ZnajdzSymbolROM(addr);
           end;
     end; {case}
end;

procedure D_MOVC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
     case OpKod of
      $83: Instr := 'MOVC'+OdstepInstrArg+'A,'+OdstepArgArg+'@A+PC';
      $93: Instr := 'MOVC'+OdstepInstrArg+'A,'+OdstepArgArg+'@A+DPTR';
     end; {case}
end;

procedure D_DIV_MUL_DA(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
     case OpKod of
      $84: Instr := 'DIV'+OdstepInstrArg+'AB';
      $A4: Instr := 'MUL'+OdstepInstrArg+'AB';
      $D4: Instr := 'DA'+OdstepInstrArg+'A';
     end; {case}
end;

procedure D_XCH(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var Data,DataAddr:Byte;
    n:string;
begin
     Instr := '';
     case OpKod of
      $C5: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+n;
           end;
      $C6: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $C7: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $C8: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $C9: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $CA: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $CB: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $CC: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $CD: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $CE: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $CF: Instr := 'XCH'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
     end; {case}
end;

procedure D_PUSH_POP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var n:string;
begin
     Instr := '';
     case OpKod of
      $C0: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'PUSH'+OdstepInstrArg+n;
           end;
      $D0: begin
                DajNazweAdresu(Bufor[2],n);
                Instr := 'POP'+OdstepInstrArg+n;
           end;
     end; {case}
end;

procedure D_SJMP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var w:word;
begin
     Instr := '';
     case OpKod of
      $80: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'SJMP'+OdstepInstrArg+'$'
                   else Instr := 'SJMP'+OdstepInstrArg+ZnajdzSymbolROM(w);
           end;
     end;
end;

procedure D_DJNZ(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var w:word;
    n:string;
begin
     Instr := '';
     case OpKod of
      $D5: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                DajNazweAdresu(Bufor[2], n);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+n+','+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+n+','+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $D8: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R0,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R0,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $D9: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R1,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R1,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $Da: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R2,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R2,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $Db: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R3,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R3,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $DC: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R4,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R4,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $DD: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R5,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R5,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $DE: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R6,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R6,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
      $DF: begin
                w := WyliczZRelokacji(ShortInt(BuFor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'DJNZ'+OdstepInstrArg+'R7,'+OdstepArgArg+'$'
                   else Instr := 'DJNZ'+OdstepInstrArg+'R7,'+OdstepArgArg+ZnajdzSymbolROM(w)
           end;
     end;
end;

procedure D_MOVX(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
     case OpKod of
      $E0: Instr := 'MOVX'+OdstepInstrArg+'A,'+OdstepArgArg+'@DPTR';
      $E2: Instr := 'MOVX'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $E3: Instr := 'MOVX'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $F0: Instr := 'MOVX'+OdstepInstrArg+'@DPTR,'+OdstepArgArg+'A';
      $F2: Instr := 'MOVX'+OdstepInstrArg+'@R0,'+OdstepArgArg+'A';
      $F3: Instr := 'MOVX'+OdstepInstrArg+'@R1,'+OdstepArgArg+'A';
     end;
end;

procedure D_XCHD(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := '';
     case OpKod of
      $D6: Instr := 'XCHD'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $D7: Instr := 'XCHD'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
     end;
end;

procedure D_CJNE(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var w:word;
    n:string;
begin
     Instr := '';
     case OpKod of
      $B4: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                         ZnajdzSymbolROM(w);
           end;
      $B5: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                DajNazweAdresu(Bufor[2], n);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'A,'+OdstepArgArg+n+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'A,'+OdstepArgArg+n+','+OdstepArgArg+ZnajdzSymbolROM(w);
           end;
      $B6: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'@R0,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'@R0,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                           ZnajdzSymbolROM(w);
           end;
      $B7: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'@R1,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'@R1,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                            ZnajdzSymbolROM(w);
           end;
      $B8: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R0,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R0,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                           ZnajdzSymbolROM(w);
           end;
      $B9: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R1,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R1,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                         ZnajdzSymbolROM(w);
           end;
      $BA: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R2,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R2,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                         ZnajdzSymbolROM(w);
           end;
      $BB: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R3,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R3,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                          ZnajdzSymbolROM(w);
           end;
      $BC: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R4,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R4,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                          ZnajdzSymbolROM(w);
           end;
      $BD: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R5,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R5,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                           ZnajdzSymbolROM(w);
           end;
      $BE: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R6,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R6,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                          ZnajdzSymbolROM(w);
           end;
      $BF: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'CJNE'+OdstepInstrArg+'R7,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+'$'
                   else Instr := 'CJNE'+OdstepInstrArg+'R7,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2])+','+OdstepArgArg+
                         ZnajdzSymbolROM(w);
           end;
     end;
end;

procedure D_JB_JNB_JBC(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var w:word;
    n:string;
begin
     Instr := '';
     case OpKod of
      $20: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                DajNazweBitu(Bufor[2], n, True);
                if w = Pozycja
                   then Instr := 'JB'+OdstepInstrArg+n+','+OdstepArgArg+'$'
                   else Instr := 'JB'+OdstepInstrArg+n+','+OdstepArgArg+ZnajdzSymbolROM(w);
           end;
      $30: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                DajNazweBitu(Bufor[2], n, True);
                if w = Pozycja
                   then Instr := 'JNB'+OdstepInstrArg+n+','+OdstepArgArg+'$'
                   else Instr := 'JNB'+OdstepInstrArg+n+','+OdstepArgArg+ZnajdzSymbolROM(w);
           end;
      $10: begin
                w := WyliczZRelokacji(ShortInt(Bufor[3]),IloscBajtow);
                DajNazweBitu(Bufor[2], n, True);
                if w = Pozycja
                   then Instr := 'JBC'+OdstepInstrArg+n+','+OdstepArgArg+'$'
                   else Instr := 'JBC'+OdstepInstrArg+n+','+OdstepArgArg+ZnajdzSymbolROM(w);
           end;
     end;{case}
end;

procedure D_JC_JNC_JZ_JNZ(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var w:word;
begin
     Instr := '';
     case OpKod of
      $40: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'JC'+OdstepInstrArg+'$'
                   else Instr := 'JC'+OdstepInstrArg+ZnajdzSymbolROM(w);
           end;
      $50: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'JNC'+OdstepInstrArg+'$'
                   else Instr := 'JNC'+OdstepInstrArg+ZnajdzSymbolROM(w);
           end;
      $60: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'JZ'+OdstepInstrArg+'$'
                   else Instr := 'JZ'+OdstepInstrArg+ZnajdzSymbolROM(w);
           end;
      $70: begin
                w := WyliczZRelokacji(ShortInt(Bufor[2]),IloscBajtow);
                if w = Pozycja
                   then Instr := 'JNZ'+OdstepInstrArg+'$'
                   else Instr := 'JNZ'+OdstepInstrArg+ZnajdzSymbolROM(w);
           end;
     end;{case}
end;

procedure D_JMP(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
begin
     Instr := 'JMP'+OdstepInstrArg+'@A+DPTR';
end;

procedure D_MOV(OpKod:Byte; IloscBajtow:Byte; Bufor:TBuforInstr; var Instr:String);
var n1,n2:string;
    Addr16:Word;
begin
     Instr := '';
     case OpKod of
      $74: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $75: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'#'+Dec2HexBH(Bufor[3]);
           end;
      $76: Instr := 'MOV'+OdstepInstrArg+'@R0,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $77: Instr := 'MOV'+OdstepInstrArg+'@R1,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $78: Instr := 'MOV'+OdstepInstrArg+'R0,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $79: Instr := 'MOV'+OdstepInstrArg+'R1,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $7A: Instr := 'MOV'+OdstepInstrArg+'R2,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $7B: Instr := 'MOV'+OdstepInstrArg+'R3,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $7C: Instr := 'MOV'+OdstepInstrArg+'R4,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $7D: Instr := 'MOV'+OdstepInstrArg+'R5,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $7E: Instr := 'MOV'+OdstepInstrArg+'R6,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
      $7F: Instr := 'MOV'+OdstepInstrArg+'R7,'+OdstepArgArg+'#'+Dec2HexBH(Bufor[2]);
{---------------------}
      $85: begin
                { Tu jest odwr¢cenie}
                DajNazweAdresu(Bufor[3], n1);
                DajNazweAdresu(Bufor[2], n2);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+n2;
           end;
      $86: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'@R0';
           end;
      $87: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'@R1';
           end;
      $88: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R0';
           end;
      $89: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R1';
           end;
      $8A: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R2';
           end;
      $8B: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R3';
           end;
      $8C: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R4';
           end;
      $8D: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R5';
           end;
      $8E: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R6';
           end;
      $8F: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'R7';
           end;
{-------------------------}
      $A2: begin
                DajNazweBitu(Bufor[2], n1, True);
                Instr := 'MOV'+OdstepInstrArg+'C,'+OdstepArgArg+n1;
           end;
{-------------------------}
      $90: begin
                Addr16 := Swap(Word(Addr(Bufor[2])^));
                Instr := 'MOV'+OdstepInstrArg+'DPTR,'+OdstepArgArg+'#'+ZnajdzSymbolRom(Addr16);
           end;
      $92: begin
                DajNazweBitu(Bufor[2], n1, True);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'C';
           end;
{-------------------------}
      $A6: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'@R0,'+OdstepArgArg+n1;
           end;
      $A7: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'@R1,'+OdstepArgArg+n1;
           end;
      $A8: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R0,'+OdstepArgArg+n1;
           end;
      $A9: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R1,'+OdstepArgArg+n1;
           end;
      $Aa: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R2,'+OdstepArgArg+n1;
           end;
      $Ab: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R3,'+OdstepArgArg+n1;
           end;
      $Ac: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R4,'+OdstepArgArg+n1;
           end;
      $Ad: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R5,'+OdstepArgArg+n1;
           end;
      $Ae: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R6,'+OdstepArgArg+n1;
           end;
      $Af: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'R7,'+OdstepArgArg+n1;
           end;
{-------------------------}
      $E5: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+n1;
           end;
      $E6: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'@R0';
      $E7: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'@R1';
      $E8: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R0';
      $E9: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R1';
      $Ea: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R2';
      $Eb: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R3';
      $Ec: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R4';
      $Ed: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R5';
      $Ee: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R6';
      $Ef: Instr := 'MOV'+OdstepInstrArg+'A,'+OdstepArgArg+'R7';
{-------------------------}
      $F5: begin
                DajNazweAdresu(Bufor[2], n1);
                Instr := 'MOV'+OdstepInstrArg+n1+','+OdstepArgArg+'A';
           end;
      $F6: Instr := 'MOV'+OdstepInstrArg+'@R0,'+OdstepArgArg+'A';
      $F7: Instr := 'MOV'+OdstepInstrArg+'@R1,'+OdstepArgArg+'A';
      $F8: Instr := 'MOV'+OdstepInstrArg+'R0,'+OdstepArgArg+'A';
      $F9: Instr := 'MOV'+OdstepInstrArg+'R1,'+OdstepArgArg+'A';
      $Fa: Instr := 'MOV'+OdstepInstrArg+'R2,'+OdstepArgArg+'A';
      $Fb: Instr := 'MOV'+OdstepInstrArg+'R3,'+OdstepArgArg+'A';
      $Fc: Instr := 'MOV'+OdstepInstrArg+'R4,'+OdstepArgArg+'A';
      $Fd: Instr := 'MOV'+OdstepInstrArg+'R5,'+OdstepArgArg+'A';
      $Fe: Instr := 'MOV'+OdstepInstrArg+'R6,'+OdstepArgArg+'A';
      $Ff: Instr := 'MOV'+OdstepInstrArg+'R7,'+OdstepArgArg+'A';
     end;{case}

end;
{**************************************************************************}
{**************************************************************************}
{**************************************************************************}
{********************** PROCEDURY WYKONUJ¤CE ******************************}
{**************************************************************************}
{**************************************************************************}
{**************************************************************************}
procedure R_NOP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
end;
procedure R_ADD(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var DataACC,DataX,DataPSW:Byte;

procedure UstawFlagi;
begin
     if DataX+DataACC > $FF
        then setBitOn(DataPSW, numerBituC)
        else setBitOff(DataPSW, numerBituC);
     if (DataX and $0F)+(DataACC and $0F) > $0F
        then setBitOn(DataPSW, numerBituAC)
        else setBitOff(DataPSW, numerBituAC);

     if (((DataX and $7F)+(DataACC and $7F) > $7F) and
        ((DataX and $80)+(DataACC and $80) = 0))
        OR (((DataX and $7F)+(DataACC and $7F) <= $7F) and
           ((DataX and $80)+(DataACC and $80) > $80))
           then setBitOn(DataPSW, numerBituOV)
           else setBitOff(DataPSW, numerBituOV);

end;

begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     DataACC := PamiecRAM[addrACC];
     DataPSW := PamiecRAM[addrPSW];
     case OpKod of
      $24: begin
                {ADD A, #x}
                DataX := Bufor[2];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $25: begin
                {ADD A, x}
                DataX := PamiecRAM[Bufor[2]];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $26: begin
                {ADD A, @R0}
                DataX := PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $27: begin
                {ADD A, @R1}
                DataX := PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $28: begin
                {ADD A, R0}
                DataX := PamiecRAM[DajAdresBanku+addrR0];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $29: begin
                {ADD A, R1}
                DataX := PamiecRAM[DajAdresBanku+addrR1];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $2A: begin
                {ADD A, R2}
                DataX := PamiecRAM[DajAdresBanku+addrR2];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $2B: begin
                {ADD A, R3}
                DataX := PamiecRAM[DajAdresBanku+addrR3];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $2C: begin
                {ADD A, R4}
                DataX := PamiecRAM[DajAdresBanku+addrR4];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $2D: begin
                {ADD A, R5}
                DataX := PamiecRAM[DajAdresBanku+addrR5];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $2E: begin
                {ADD A, R6}
                DataX := PamiecRAM[DajAdresBanku+addrR6];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
      $2F: begin
                {ADD A, R7}
                DataX := PamiecRAM[DajAdresBanku+addrR7];
                UstawFlagi;
                Inc(DataACC, DataX);
           end;
     end; {case}

     PamiecRAM[addrACC] := DataACC;
     PamiecRAM[addrPSW] := DataPSW;
end;

procedure R_MOV(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var adr,bit:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
      $74: {MOV A, data} PamiecRAM[addrACC] := Bufor[2];
      $75: {MOV addr, data}
           begin
                PamiecRAM[Bufor[2]] := Bufor[3];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
{MOV @R0, data}
      $76: PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] := Bufor[2];
{MOV @R1, data}
      $77: PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] := Bufor[2];
{MOV R0-7, data}
      $78: PamiecRAM[DajAdresBanku+addrR0] := Bufor[2];
      $79: PamiecRAM[DajAdresBanku+addrR1] := Bufor[2];
      $7A: PamiecRAM[DajAdresBanku+addrR2] := Bufor[2];
      $7B: PamiecRAM[DajAdresBanku+addrR3] := Bufor[2];
      $7C: PamiecRAM[DajAdresBanku+addrR4] := Bufor[2];
      $7D: PamiecRAM[DajAdresBanku+addrR5] := Bufor[2];
      $7E: PamiecRAM[DajAdresBanku+addrR6] := Bufor[2];
      $7F: PamiecRAM[DajAdresBanku+addrR7] := Bufor[2];
{---------------------}
      { Tu jest odwr¢cenie - MOV addr, addr}
      $85: begin
                PamiecRAM[Bufor[3]] := PamiecRAM[Bufor[2]];
                WpisDoSBUF := Bufor[3] = addrSBUF;
           end;
{mov addr, @r0}
      $86: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;

{mov addr, @r1}
      $87: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
{mov addr, r0-7}
      $88: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR0];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $89: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR1];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $8A: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR2];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $8B: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR3];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $8C: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR4];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $8D: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR5];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $8E: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR6];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
      $8F: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[DajAdresBanku+addrR7];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
{-------------------------}
{mov c, bit addr}
      $A2: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                if isBitOn(PamiecRAM[adr], bit)
                then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                else SetBitOff(PamiecRAM[addrPSW], numerBituC)

           end;
{-------------------------}
{mov dptr, data16}
      $90: begin
                PamiecRAM[addrDPH] := Bufor[2];
                PamiecRAM[addrDPL] := Bufor[3];
           end;

{mov bit addr, c}
      $92: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                if isBitOn(PamiecRAM[addrPSW], numerBituC)
                then SetBitOn(PamiecRAM[adr], bit)
                else SetBitOff(PamiecRAM[adr], bit)
           end;
{-------------------------}
{MOV @R0, ADDR}
      $A6: PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] := PamiecRam[Bufor[2]];
{MOV @R1, ADDR}
      $A7: PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] := PamiecRam[Bufor[2]];
{MOV R0-7, ADDR}
      $A8: PamiecRAM[DajAdresBanku+addrR0] := PamiecRam[Bufor[2]];
      $A9: PamiecRAM[DajAdresBanku+addrR1] := PamiecRam[Bufor[2]];
      $Aa: PamiecRAM[DajAdresBanku+addrR2] := PamiecRam[Bufor[2]];
      $Ab: PamiecRAM[DajAdresBanku+addrR3] := PamiecRam[Bufor[2]];
      $Ac: PamiecRAM[DajAdresBanku+addrR4] := PamiecRam[Bufor[2]];
      $Ad: PamiecRAM[DajAdresBanku+addrR5] := PamiecRam[Bufor[2]];
      $Ae: PamiecRAM[DajAdresBanku+addrR6] := PamiecRam[Bufor[2]];
      $Af: PamiecRAM[DajAdresBanku+addrR7] := PamiecRam[Bufor[2]];
{-------------------------}
{MOV A, ADDR}
      $E5: PamiecRAM[addrACC] := PamiecRam[Bufor[2]];
{mov a, @r0}
      $E6: PamiecRAM[addrACC] := PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
{mov a, @r1}
      $E7: PamiecRAM[addrACC] := PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
{mov a, r0-7}
      $E8: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR0];
      $E9: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR1];
      $Ea: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR2];
      $Eb: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR3];
      $Ec: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR4];
      $Ed: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR5];
      $Ee: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR6];
      $Ef: PamiecRAM[addrACC] := PamiecRAM[DajAdresBanku+addrR7];
{-------------------------}
{MOV ADDR, A}
      $F5: begin
                PamiecRam[Bufor[2]] := PamiecRAM[addrACC];
                WpisDoSBUF := Bufor[2] = addrSBUF;
           end;
{mov @r0, A}
      $F6: PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] := PamiecRAM[addrACC];
{mov @r1, a}
      $F7: PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] := PamiecRAM[addrACC];
{mov r0-7, a}
      $F8: PamiecRAM[DajAdresBanku+addrR0] := PamiecRAM[addrACC];
      $F9: PamiecRAM[DajAdresBanku+addrR1] := PamiecRAM[addrACC];
      $Fa: PamiecRAM[DajAdresBanku+addrR2] := PamiecRAM[addrACC];
      $Fb: PamiecRAM[DajAdresBanku+addrR3] := PamiecRAM[addrACC];
      $Fc: PamiecRAM[DajAdresBanku+addrR4] := PamiecRAM[addrACC];
      $Fd: PamiecRAM[DajAdresBanku+addrR5] := PamiecRAM[addrACC];
      $Fe: PamiecRAM[DajAdresBanku+addrR6] := PamiecRAM[addrACC];
      $Ff: PamiecRAM[DajAdresBanku+addrR7] := PamiecRAM[addrACC];
     end;{case}

end;
procedure R_CLR(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var bit,adr:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{clr bit addr}
      $C2: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                SetBitOff(PamiecRAM[adr], bit);
           end;
{clr c}
      $C3: SetBitOff(PamiecRAM[addrPSW], numerBituC);
{clr acc}
      $E4: PamiecRAM[addrACC] := $00;
     end; {case}
end;

procedure R_CPL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var Nazwa:String;
    bit,adr:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{cpl bit addr}
      $B2: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                if isBitOn(pamiecram[adr], bit)
                then SetBitOff(pamiecram[adr], bit)
                else SetBitOn(PamiecRAM[adr], bit)
           end;
{cpl c}
      $B3: begin
                if isBitOn(PamiecRAM[addrPSW], numerBituC)
                then SetBitOff(PamiecRAM[addrPSW], numerBituC)
                else SetBitOn(PamiecRAM[addrPSW], numerBituC)
           end;
{cpl acc}
      $F4: PamiecRAM[addrACC] := not PamiecRam[addrACC];
     end; {case}
end;

procedure R_SWAP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var temp:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     temp := (PamiecRAM[addrACC] and $F0) shr 4;
     PamiecRAM[addrACC] :=  (PamiecRAM[addrACC] shl 4) or temp;
end;

procedure R_SETB(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var bit,adr:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{setb bitaddr}
      $D2: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                SetBitOn(PamiecRAM[adr], bit);
           end;
      $D3: setBitOn(PamiecRAM[addrPSW], numerBituC);
     end; {case}
end;

procedure R_DA(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var A3_0,A7_4:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);

     A7_4 := (PamiecRAM[addrACC] and $F0) shr 4;
     A3_0 := (PamiecRAM[addrACC] and $0F);
     if (a3_0 > 9) or isBitOn(PamiecRAM[addrPSW], numerBituAC) then
     begin
          if a3_0+6 > $0F then Inc(a7_4);
          Inc(a3_0,6);
     end;
     if (a7_4 > 9) or isBitOn(PamiecRAM[addrPSW], numerBituC) then
     begin
          if a7_4+6 > $0F then setBitOn(PamiecRAM[addrPSW], numerBituC);
          Inc(a7_4,6);
     end;
     PamiecRAM[addrACC] := (A7_4 shl 4) or (A3_0 and $0F);
end;

procedure R_PUSH_POP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{push addr}
      $C0: begin
                Inc(PamiecRAM[addrSP]);
                PamiecRAM[PamiecRAM[addrSP]] := PamiecRAM[Bufor[2]];
           end;
{pop addr}
      $D0: begin
                PamiecRAM[Bufor[2]] := PamiecRAM[PamiecRAM[addrSP]];
                Dec(PamiecRAM[addrSP]);
           end;
     end; {case}
end;

procedure R_INC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var dptr:word;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{inc a}
      $04: Inc(PamiecRAM[addrACC]);
{inc addr}
      $05:Inc(PamiecRAM[Bufor[2]]);
{inc @r0}
      $06: Inc(PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]]);
{inc @r0}
      $07: Inc(PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]]);
{inc r0-7}
      $08: Inc(PamiecRAM[DajAdresBanku+addrR0]);
      $09: Inc(PamiecRAM[DajAdresBanku+addrR1]);
      $0a: Inc(PamiecRAM[DajAdresBanku+addrR2]);
      $0b: Inc(PamiecRAM[DajAdresBanku+addrR3]);
      $0c: Inc(PamiecRAM[DajAdresBanku+addrR4]);
      $0d: Inc(PamiecRAM[DajAdresBanku+addrR5]);
      $0e: Inc(PamiecRAM[DajAdresBanku+addrR6]);
      $0f: Inc(PamiecRAM[DajAdresBanku+addrR7]);
{inc dptr}
      $A3: begin
                dptr := (PamiecRAM[addrDPH] shl 8) or PamiecRAM[addrDPL];
                Inc(Dptr);
                PamiecRAM[addrDPH] := (dptr and $FF00) shr 8;
                PamiecRAM[addrDPL] := dptr and $00FF;
           end;
     end; {case}
end;

procedure R_DEC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{dec a}
      $14: dec(PamiecRAM[addrACC]);
{dec addr}
      $15: dec(PamiecRAM[Bufor[2]]);
{dec @r0}
      $16: dec(PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]]);
{dec @r0}
      $17: dec(PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]]);
{dec r0-7}
      $18: dec(PamiecRAM[DajAdresBanku+addrR0]);
      $19: dec(PamiecRAM[DajAdresBanku+addrR1]);
      $1a: dec(PamiecRAM[DajAdresBanku+addrR2]);
      $1b: dec(PamiecRAM[DajAdresBanku+addrR3]);
      $1c: dec(PamiecRAM[DajAdresBanku+addrR4]);
      $1d: dec(PamiecRAM[DajAdresBanku+addrR5]);
      $1e: dec(PamiecRAM[DajAdresBanku+addrR6]);
      $1f: dec(PamiecRAM[DajAdresBanku+addrR7]);
     end;
end;

procedure R_ADDC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var DataACC,DataX,DataPSW:Byte;
    n:string;
    DataCY:Byte;

procedure UstawFlagi;
begin
     if DataX+DataACC+DataCY > $FF
        then setBitOn(DataPSW, numerBituC)
        else setBitOff(DataPSW, numerBituC);
     if (DataX and $0F)+(DataACC and $0F)+DataCY > $0F
        then setBitOn(DataPSW, numerBituAC)
        else setBitOff(DataPSW, numerBituAC);

     if (((DataX and $7F)+(DataACC and $7F)+DataCY > $7F) and
        ((DataX and $80)+(DataACC and $80) = 0))
        OR (((DataX and $7F)+(DataACC and $7F)+DataCY <= $7F) and
           ((DataX and $80)+(DataACC and $80) > $80))
           then setBitOn(DataPSW, numerBituOV)
           else setBitOff(DataPSW, numerBituOV);

end;

begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     DataACC := PamiecRAM[addrACC];
     DataPSW := PamiecRAM[addrPSW];
     DataCY := 0;
     if isBitOn(DataPSW, numerBituC) then DataCY := 1;
     case OpKod of
      $34: begin
{ADDC A, #x}
                DataX := Bufor[2];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $35: begin
{ADDC A, x}
                DataX := Bufor[2];
                DataX := PamiecRAM[DataX];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $36: begin
{ADDC A, @R0}
                DataX := PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $37: begin
{ADDC A, @R1}
                DataX := PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $38: begin
{ADDC A, R0}
                DataX := PamiecRAM[DajAdresBanku+addrR0];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $39: begin
{ADDC A, R1}
                DataX := PamiecRAM[DajAdresBanku+addrR1];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $3A: begin
{ADDC A, R2}
                DataX := PamiecRAM[DajAdresBanku+addrR2];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $3B: begin
{ADDC A, R3}
                DataX := PamiecRAM[DajAdresBanku+addrR3];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $3C: begin
{ADDC A, R4}
                DataX := PamiecRAM[DajAdresBanku+addrR4];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $3D: begin
{ADDC A, R5}
                DataX := PamiecRAM[DajAdresBanku+addrR5];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $3E: begin
{ADDC A, R6}
                DataX := PamiecRAM[DajAdresBanku+addrR6];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
      $3F: begin
      {ADDC A, R7}
                DataX := PamiecRAM[DajAdresBanku+addrR7];
                UstawFlagi;
                Inc(DataACC, DataX);
                Inc(DataACC, DataCY);
           end;
     end; {case}

     PamiecRAM[addrACC] := DataACC;
     PamiecRAM[addrPSW] := DataPSW;
end;

procedure R_RR_RL_RRC_RLC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var DataACC, Wartosc:Byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     DataACC := PamiecRAM[addrACC];
     Wartosc := 0;
     case OpKod of
{RL A}
      $23: begin
                if DataACC and $80 <> 0 then Wartosc := 1;
                DataACC := (DataACC shl 1) or Wartosc
           end;
{RLC A}
      $33: begin
                if isBitOn(PamiecRAM[addrPSW], numerBituC) then Wartosc := 1
                                                             else Wartosc := 0;
                if (DataACC and $80) <> 0 then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                          else SetBitOff(PamiecRAM[addrPSW], numerBituC);
                DataACC := (DataACC shl 1) or Wartosc;
           end;
{RR A}
      $03: begin
                Wartosc := DataACC and 1;
                DataACC := (DataACC shr 1) or (Wartosc shl 7);
           end;
{RRC A}
      $13: begin
                if isBitOn(PamiecRAM[addrPSW], numerBituC) then Wartosc := $80
                                                           else Wartosc := 0;
                if (DataACC and 1) <> 0 then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                        else SetBitOff(PamiecRAM[addrPSW], numerBituC);
                DataACC := (DataACC shr 1) or Wartosc;
           end;
     end; {case}
     PamiecRAM[addrACC] := DataACC;
end;

procedure R_LCALL_LJMP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var addr16:Word;
begin
{     NaglaZmianaPC := True;}
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     Addr16 := Swap(Word(Addr(Bufor[2])^));
     case OpKod of
{LCALL ADDR16}
      $12: begin
                Inc(PamiecRAM[addrSP]);
                PamiecRAM[PamiecRAM[addrSP]] := Lo(PC);
                Inc(PamiecRAM[addrSP]);
                PamiecRAM[PamiecRAM[addrSP]] := Hi(PC);
                PC := Addr16;
           end;
{Ljmp ADDR16}
      $02: PC := Addr16;
     end; {case}
end;

procedure R_RET_RETI(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
{     NaglaZmianaPC := True;}
{     Inc(PC, IloscBajtow);}
     Inc(IloscCykli, Cykle);
     case OpKod of
{ret}
      $22: begin
                PC := PamiecRAM[PamiecRAM[addrSP]] shl 8;
                Dec(PamiecRAM[addrSP]);
                PC := PC or PamiecRAM[PamiecRAM[addrSP]];
                Dec(PamiecRAM[addrSP]);
           end;
{reti}
      $32: begin

                PC := PamiecRAM[PamiecRAM[addrSP]] shl 8;
                Dec(PamiecRAM[addrSP]);
                PC := PC or PamiecRAM[PamiecRAM[addrSP]];
                Dec(PamiecRAM[addrSP]);
                if WykonywaneIntHi then
                begin
                     WykonywaneIntHi := False;
                     Exit;
                end;
                WykonywaneIntLo := False;
           end;
     end; {case}
end;

procedure R_AJMP_ACALL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var addrb:byte;
    addr:word;
begin
{     NaglaZmianaPC := True;}
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{ajmp addr13}
      $01,$21,$41,$61,$81,$A1,$C1,$E1 :
           begin
                addrb := OpKod and $E0;
                addrb := addrb shr 5;
                addr := bufor[2];
                addr := addr or (addrb shl 8);
                PC := Addr;
           end;
{acall addr13}
      $11,$31,$51,$71,$91,$b1,$d1,$f1 :
           begin
                addrb := OpKod and $E0;
                addrb := addrb shr 5;
                addr := bufor[2];
                addr := addr or (addrb shl 8);
                Inc(PamiecRAM[addrSP]);
                PamiecRAM[PamiecRAM[addrSP]] := Lo(PC);
                Inc(PamiecRAM[addrSP]);
                PamiecRAM[PamiecRAM[addrSP]] := Hi(PC);
                PC := Addr;
           end;
     end; {case}
end;

procedure R_JB_JNB_JBC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var w:word;
    bit,adr:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     adr:=Bufor[2];
     if adr in [$00..$7F] then
     begin
          bit := adr mod 8;
          adr := $20 + adr div 8;
     end else
     begin
          bit := adr and $07;
          adr := adr and $F8;
     end;
     case OpKod of
{jb rel8}
      $20: begin
                if IsBitOn(pamiecram[adr], bit) then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
           end;
{jnb rel8}
      $30: begin
                if not IsBitOn(pamiecram[adr], bit) then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
           end;
{jbc rel8}
      $10: begin
                if IsBitOn(pamiecram[adr], bit) then
                begin
                     SetBitOff(pamiecram[adr], bit);
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
           end;
     end;{case}
end;

procedure R_JC_JNC_JZ_JNZ(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var w:word;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{jc rel8}
      $40: begin
{                if IsBitOn(PamiecRAM[addrPSW], numerBituC) then}
                if PamiecRAM[addrPSW] and numerBituC <> 0 then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
{jnc rel8}
      $50: begin
                if PamiecRAM[addrPSW] and numerBituC = 0 then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
{jz rel8}
      $60: begin
                if PamiecRAM[addrACC] = 0 then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
{jnz rel8}
      $70: begin
                if not(PamiecRAM[addrACC] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
     end;{case}
end;
procedure R_DIV_MUL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var wyn16:word;
    wyn8,reszta8:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{DIV AB}
      $84: begin
                setBitOff(PamiecRAM[addrPSW], numerBituC);
                if PamiecRAM[addrB] = 0 then
                begin
                     setBitOn(PamiecRAM[addrPSW], numerBituOV);
                     Exit;
                end;
                wyn8 := PamiecRAM[addrACC] div PamiecRAM[addrB];
                reszta8 := PamiecRAM[addrACC] mod PamiecRAM[addrB];
                PamiecRAM[addrACC] := wyn8;
                PamiecRAM[addrB] := reszta8;
           end;

{MUL AB}
      $A4: begin
                setBitOff(PamiecRAM[addrPSW], numerBituC);
                wyn16 := PamiecRAM[addrACC]*PamiecRAM[addrB];
                if wyn16 > $FF then setBitOn(PamiecRAM[addrPSW], numerBituOV)
                               else setBitOff(PamiecRAM[addrPSW], numerBituOV);
                PamiecRAM[addrACC] := Lo(Wyn16);
                PamiecRAM[addrB] := Hi(Wyn16);
           end;
     end; {case}
end;

procedure R_ORL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var d1,d2:Boolean;
    adr,bit:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{orl addr, A}
      $42: PamiecRAM[Bufor[2]] := PamiecRAM[bufor[2]] or PamiecRAM[addrACC];
{orl addr, #data}
      $43: PamiecRAM[Bufor[2]] := PamiecRAM[bufor[2]] or Bufor[3];
{orl a, #data}
      $44: PamiecRAM[addrACC] := PamiecRAM[addrACC] or Bufor[2];
{orl A, addr}
      $45: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[bufor[2]];
{orl a, @r0-1}
      $46: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
      $47: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
{orl a, r0-7}
      $48: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR0];
      $49: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR1];
      $4a: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR2];
      $4b: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR3];
      $4c: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR4];
      $4d: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR5];
      $4e: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR6];
      $4f: PamiecRAM[addrACC] := PamiecRAM[addrACC] or PamiecRAM[DajAdresBanku+addrR7];
{orl c, bit}
      $72: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                d1 := IsBitOn(PamiecRAM[addrPSW], numerBituC);
                d2 := IsBitOn(pamiecram[adr], bit);
                d1 := d1 or d2;
                if d1 then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                      else SetBitOff(PamiecRAM[addrPSW], numerBituC);
           end;
{orl c, /bit}
      $A0: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                d1 := IsBitOn(PamiecRAM[addrPSW], numerBituC);
                d2 := IsBitOn(PamiecRam[adr], bit);
                d1 := d1 or (not d2);
                if d1 then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                      else SetBitOff(PamiecRAM[addrPSW], numerBituC);
           end;
     end; {case}
end;

procedure R_XRL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var d1,d2:Boolean;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{xrl addr, A}
      $62: PamiecRAM[Bufor[2]] := PamiecRAM[bufor[2]] xor PamiecRAM[addrACC];
{xrl addr, #data}
      $63: PamiecRAM[Bufor[2]] := PamiecRAM[bufor[2]] xor Bufor[3];
{xrl a, #data}
      $64: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor Bufor[2];
{xrl A, addr}
      $65: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[bufor[2]];
{xrl a, @r0-1}
      $66: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
      $67: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
{xrl a, r0-7}
      $68: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR0];
      $69: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR1];
      $6a: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR2];
      $6b: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR3];
      $6c: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR4];
      $6d: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR5];
      $6e: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR6];
      $6f: PamiecRAM[addrACC] := PamiecRAM[addrACC] xor PamiecRAM[DajAdresBanku+addrR7];
     end; {case}
end;

procedure R_ANL(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var d1,d2:Boolean;
    adr,bit:byte;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{anl addr, A}
      $52: PamiecRAM[Bufor[2]] := PamiecRAM[bufor[2]] and PamiecRAM[addrACC];
{anl addr, #data}
      $53: PamiecRAM[Bufor[2]] := PamiecRAM[bufor[2]] and Bufor[3];
{anl a, #data}
      $54: PamiecRAM[addrACC] := PamiecRAM[addrACC] and Bufor[2];
{anl A, addr}
      $55: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[bufor[2]];
{anl a, @r0-1}
      $56: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
      $57: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
{anl a, r0-7}
      $58: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR0];
      $59: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR1];
      $5a: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR2];
      $5b: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR3];
      $5c: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR4];
      $5d: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR5];
      $5e: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR6];
      $5f: PamiecRAM[addrACC] := PamiecRAM[addrACC] and PamiecRAM[DajAdresBanku+addrR7];
{anl c, bit}
      $82: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                d1 := IsBitOn(PamiecRAM[addrPSW], numerBituC);
                d2 := IsBitOn(PamiecRAM[adr], bit);
                d1 := d1 and d2;
                if d1 then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                      else SetBitOff(PamiecRAM[addrPSW], numerBituC);
           end;
{anl c, /bit}
      $b0: begin
                adr:=Bufor[2];
                if adr in [$00..$7F] then
                begin
                     bit := adr mod 8;
                     adr := $20 + adr div 8;
                end else
                begin
                     bit := adr and $07;
                     adr := adr and $F8;
                end;
                d1 := IsBitOn(PamiecRAM[addrPSW], numerBituC);
                d2 := IsBitOn(pamiecram[adr], bit);
                d1 := d1 and (not d2);
                if d1 then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                      else SetBitOff(PamiecRAM[addrPSW], numerBituC);
           end;
     end; {case}
end;

procedure R_MOVC(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var baza:word;
begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     case OpKod of
{movc a, @a+pc}
      $83: baza := pc;
{movc a, @a+dptr}
      $93: baza := (PamiecRAM[addrDPH] shl 8) or PamiecRAM[addrDPL];
     end; {case}
     inc(baza, PamiecRAM[addrACC]);
     PamiecRAM[addrACC] := PamiecROM^[Baza];
end;

procedure R_JMP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var baza:word;
begin
     {jmp @a+dptr}
{     Inc(PC, IloscBajtow);}
     Inc(IloscCykli, Cykle);

     baza := (PamiecRAM[addrDPH] shl 8) or PamiecRAM[addrDPL];
     inc(baza, PamiecRAM[addrACC]);
     PC := Baza;
end;

procedure R_SJMP(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
{     NaglaZmianaPC := True;}
     Inc(IloscCykli, Cykle);
     Inc(PC, IloscBajtow);
     Inc(PC, ShortInt(Bufor[2]));
end;

procedure R_XCH(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(IloscCykli, Cykle);
     Inc(PC, IloscBajtow);
     case OpKod of
{xch a, addr}
      $C5: Wymien(PamiecRAM[addrACC], PamiecRAM[Bufor[2]]);
{xch a, @r0}
      $C6: Wymien(PamiecRAM[addrACC], PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]]);
{xch a, @r1}
      $C7: Wymien(PamiecRAM[addrACC], PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]]);
{xch a, r07}
      $C8: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR0]);
      $C9: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR1]);
      $CA: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR2]);
      $CB: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR3]);
      $CC: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR4]);
      $CD: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR5]);
      $CE: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR6]);
      $CF: Wymien(PamiecRAM[addrACC], PamiecRAM[DajAdresBanku+addrR7]);
     end; {case}
end;

procedure R_XCHD(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var w1,w2:byte;
begin
     Inc(IloscCykli, Cykle);
     Inc(PC, IloscBajtow);
     case OpKod of
{xchd a, @r0}
      $D6: begin
                w1 := PamiecRAM[addrACC] and $0F;
                w2 := PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] and $0F;
                PamiecRAM[addrACC] := (PamiecRAM[addrACC] and $F0) or w2;
                PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] := (PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] and $F0) or w1;
           end;
{xchd a, @r1}
      $D7: begin
                w1 := PamiecRAM[addrACC] and $0F;
                w2 := PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] and $0F;
                PamiecRAM[addrACC] := (PamiecRAM[addrACC] and $F0) or w2;
                PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] := (PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] and $F0) or w1;
           end;
     end;
end;

procedure R_DJNZ(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(IloscCykli, Cykle);
     Inc(PC, IloscBajtow);
     case OpKod of
{djnz addr data, addr code}
      $D5: begin
                Dec(PamiecRAM[Bufor[2]]);
                if not (PamiecRAM[Bufor[2]] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
           end;
{djnz r0-7, addr code}
      $D8: begin
                Dec(PamiecRAM[DajAdresBanku+addrR0]);
                if not (PamiecRAM[DajAdresBanku+addrR0] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $D9: begin
                Dec(PamiecRAM[DajAdresBanku+addrR1]);
                if not (PamiecRAM[DajAdresBanku+addrR1] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $Da: begin
                Dec(PamiecRAM[DajAdresBanku+addrR2]);
                if not (PamiecRAM[DajAdresBanku+addrR2] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $Db: begin
                Dec(PamiecRAM[DajAdresBanku+addrR3]);
                if not (PamiecRAM[DajAdresBanku+addrR3] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $DC: begin
                Dec(PamiecRAM[DajAdresBanku+addrR4]);
                if not (PamiecRAM[DajAdresBanku+addrR4] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $DD: begin
                Dec(PamiecRAM[DajAdresBanku+addrR5]);
                if not (PamiecRAM[DajAdresBanku+addrR5] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $DE: begin
                Dec(PamiecRAM[DajAdresBanku+addrR6]);
                if not (PamiecRAM[DajAdresBanku+addrR6] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
      $DF: begin
                Dec(PamiecRAM[DajAdresBanku+addrR7]);
                if not (PamiecRAM[DajAdresBanku+addrR7] = 0) then
                begin
                     Inc(PC, ShortInt(Bufor[2]));
{                     NaglaZmianaPC := True;}
                end;
           end;
     end;
end;

procedure R_CJNE(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
begin
     Inc(IloscCykli, Cykle);
     Inc(PC, IloscBajtow);
     case OpKod of
{cjne a, #data, rel}
      $B4: begin
                if PamiecRAM[addrACC] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[addrACC] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                 else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
{cjne a, addr, rel}
      $B5: begin
                if PamiecRAM[addrACC] <> PamiecRAM[Bufor[2]] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[addrACC] < PamiecRAM[Bufor[2]] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                            else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
{cjne @r0, #data, rel}
      $B6: begin
                if PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                                         else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
{cjne @r1, #data, rel}
      $B7: begin
                if PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                                         else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
{cjne r0-7, #data, rel}
      $B8: begin
                if PamiecRAM[DajAdresBanku+addrR0] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR0] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $B9: begin
                if PamiecRAM[DajAdresBanku+addrR1] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR1] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $BA: begin
                if PamiecRAM[DajAdresBanku+addrR2] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR2] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $BB: begin
                if PamiecRAM[DajAdresBanku+addrR3] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR3] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $BC: begin
                if PamiecRAM[DajAdresBanku+addrR4] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR4] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $BD: begin
                if PamiecRAM[DajAdresBanku+addrR5] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR5] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $BE: begin
                if PamiecRAM[DajAdresBanku+addrR6] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR6] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
      $BF: begin
                if PamiecRAM[DajAdresBanku+addrR7] <> Bufor[2] then
                begin
                     Inc(PC, ShortInt(Bufor[3]));
{                     NaglaZmianaPC := True;}
                end;
                if PamiecRAM[DajAdresBanku+addrR7] < Bufor[2] then SetBitOn(PamiecRAM[addrPSW], numerBituC)
                                                              else SetBitOff(PamiecRAM[addrPSW], numerBituC)
           end;
     end;
end;

procedure R_SUBB(OpKod,IloscBajtow,Cykle:Byte; Bufor:TBuforInstr);
var DataACC,DataX,DataPSW:Byte;
    DataCY:Byte;
Procedure UstawFlagi;
begin
     if ((DataX+DataCY) > DataACC) xor ((DataX+DataCY) and $7F > DataACC and $7F)
        then setBitOn(DataPSW, numerBituOV)
        else setBitOff(DataPSW, numerBituOV);

     if DataACC-DataX-DataCY < $00
        then setBitOn(DataPSW, numerBituC)
        else setBitOff(DataPSW, numerBituC);

     if (DataACC and $0F)-(DataX and $0F)-DataCY < $00
        then setBitOn(DataPSW, numerBituAC)
        else setBitOff(DataPSW, numerBituAC);
end;

begin
     Inc(PC, IloscBajtow);
     Inc(IloscCykli, Cykle);
     DataACC := PamiecRAM[addrACC];
     DataPSW := PamiecRAM[addrPSW];
     DataCY := 0;
     if isBitOn(DataPSW, numerBituC) then DataCY := 1;
     case OpKod of
{subb a, #data}
      $94: begin
                DataX := Bufor[2];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
{subb a, addr}
      $95: begin
                DataX := PamiecRAM[Bufor[2]];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
{subb a, @r0}
      $96: begin
                DataX := PamiecRAM[PamiecRAM[DajAdresBanku+addrR0]];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
{subb a, @r1}
      $97: begin
                DataX := PamiecRAM[PamiecRAM[DajAdresBanku+addrR1]];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
{subb a, r0-7}
      $98: begin
                DataX := PamiecRAM[DajAdresBanku+addrR0];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $99: begin
                DataX := PamiecRAM[DajAdresBanku+addrR1];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $9A: begin
                DataX := PamiecRAM[DajAdresBanku+addrR2];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $9B: begin
                DataX := PamiecRAM[DajAdresBanku+addrR3];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $9C: begin
                DataX := PamiecRAM[DajAdresBanku+addrR4];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $9D: begin
                DataX := PamiecRAM[DajAdresBanku+addrR5];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $9E: begin
                DataX := PamiecRAM[DajAdresBanku+addrR6];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
      $9F: begin
                DataX := PamiecRAM[DajAdresBanku+addrR7];
                UstawFlagi;
                Dec(DataACC, DataX);
                Dec(DataACC, DataCY);
           end;
     end; {case}
     PamiecRAM[addrACC] := DataACC;
     PamiecRAM[addrPSW] := DataPSW;
end;

end.
