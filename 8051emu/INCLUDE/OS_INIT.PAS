constructor TOknoSledzenia.Init;
var r:Trect;
    Control : PView;
begin
     R.Assign(0, 0, 80, 23);
     inherited Init(R, '—ledzenia pracy mikroprocesora', wnNoNumber);
     GrowMode := gfGrowHiY;
     Palette := wpCyanWindow;
     HelpCtx := hcOknoCPU;

     R.Assign(61, 1, 62, 22);
     Control := New(PColoredText, Init(R, '³³³³³³³³³³³³³³³³³³³³³', $3F, 0));
     Control^.GrowMode := gfGrowHiY;
     Insert(Control);

     R.Assign(62, 1, 64, 2);
     Control := New(PColoredText, Init(R, 'A=', $30, 0));
     Insert(Control);

     R.Assign(67, 1, 69, 2);
     Control := New(PColoredText, Init(R, 'B=', $30, 0));
     Insert(Control);

     R.Assign(62, 2, 67, 3);
     Control := New(PColoredText, Init(R, 'DPTR=', $30, 0));
     Insert(Control);

     R.Assign(62, 3, 65, 4);
     Control := New(PColoredText, Init(R, 'PC=', $30, 0));
     Insert(Control);

     R.Assign(62, 4, 65, 5);
     Control := New(PColoredText, Init(R, 'R0=', $30, 0));
     Insert(Control);

     R.Assign(68, 4, 71, 5);
     Control := New(PColoredText, Init(R, 'R1=', $30, 0));
     Insert(Control);

     R.Assign(62, 5, 65, 6);
     Control := New(PColoredText, Init(R, 'R2=', $30, 0));
     Insert(Control);

     R.Assign(68, 5, 71, 6);
     Control := New(PColoredText, Init(R, 'R3=', $30, 0));
     Insert(Control);

     R.Assign(62, 6, 65, 7);
     Control := New(PColoredText, Init(R, 'R4=', $30, 0));
     Insert(Control);

     R.Assign(68, 6, 71, 7);
     Control := New(PColoredText, Init(R, 'R5=', $30, 0));
     Insert(Control);

     R.Assign(68, 7, 71, 8);
     Control := New(PColoredText, Init(R, 'R7=', $30, 0));
     Insert(Control);

     R.Assign(62, 7, 65, 8);
     Control := New(PColoredText, Init(R, 'R6=', $30, 0));
     Insert(Control);

     R.Assign(62, 8, 65, 9);
     Control := New(PColoredText, Init(R, 'P1=', $30, 0));
     Insert(Control);

     R.Assign(68, 8, 71, 9);
     Control := New(PColoredText, Init(R, 'P3=', $30, 0));
     Insert(Control);

     R.Assign(62, 9, 65, 10);
     Control := New(PColoredText, Init(R, 'SP=', $30, 0));
     Insert(Control);

     R.Assign(62, 10, 65, 11);
     Control := New(PColoredText, Init(R, 'T0=', $30, 0));
     Insert(Control);

     R.Assign(62, 11, 65, 12);
     Control := New(PColoredText, Init(R, 'T1=', $30, 0));
     Insert(Control);

     R.Assign(62, 12, 67, 13);
     Control := New(PColoredText, Init(R, 'TCON=', $30, 0));
     Insert(Control);

     R.Assign(62, 13, 67, 14);
     Control := New(PColoredText, Init(R, 'SBUF=', $30, 0));
     Insert(Control);

     R.Assign(62, 14, 67, 15);
     Control := New(PColoredText, Init(R, 'SCON=', $30, 0));
     Insert(Control);

     R.Assign(62, 15, 67, 16);
     Control := New(PColoredText, Init(R, 'PCON=', $30, 0));
     Insert(Control);

     R.Assign(62, 16, 67, 17);
     Control := New(PColoredText, Init(R, 'TMOD=', $30, 0));
     Insert(Control);

     R.Assign(62, 17, 65, 18);
     Control := New(PColoredText, Init(R, 'IE=', $30, 0));
     Insert(Control);

     R.Assign(68, 17, 71, 18);
     Control := New(PColoredText, Init(R, 'IP=', $30, 0));
     Insert(Control);

     R.Assign(62, 18, 65, 19);
     Control := New(PColoredText, Init(R, 'Ck=', $30, 0));
     Insert(Control);


     R.Assign(75, 1, 79, 2);
     FlagaCY := New(PColoredText, Init(R, 'cy', $30, cmFlagaCY));
     Insert(FlagaCY);

     R.Assign(75, 2, 79, 3);
     FlagaAC := New(PColoredText, Init(R, 'ac', $30, cmFlagaAC));
     Insert(FlagaAC);

     R.Assign(75, 3, 79, 4);
     FlagaF0 := New(PColoredText, Init(R, 'f0', $30, cmFlagaF0));
     Insert(FlagaF0);

     R.Assign(75, 4, 79, 5);
     FlagaRS1 := New(PColoredText, Init(R, 'rs1', $30, cmFlagaRS1));
     Insert(FlagaRS1);

     R.Assign(75, 5, 79, 6);
     FlagaRS0 := New(PColoredText, Init(R, 'rs0', $30, cmFlagaRS0));
     Insert(FlagaRS0);

     R.Assign(75, 6, 79, 7);
     FlagaOV := New(PColoredText, Init(R, 'ov', $30, cmFlagaOV));
     Insert(FlagaOV);

     R.Assign(75, 7, 79, 8);
     FlagaUNDEF := New(PColoredText, Init(R, '----', $30, cmFlagaUNDEF));
     Insert(FlagaUNDEF);

     R.Assign(75, 8, 79, 9);
     FlagaP := New(PColoredText, Init(R, 'p', $30, cmFlagaP));
     Insert(FlagaP);

     R.Assign(74, 9, 79, 10);
     Control := New(PColoredText, Init(R, 'Bank:', $30, 0));
     Insert(Control);

     R.Assign(75, 10, 77, 11);
     NumerBanku := New(PColoredText, Init(R, '0', $31, 0));
     Insert(NumerBanku);

     R.Assign(73, 1, 74, 22);
     Control := New(PColoredText, Init(R, '³³³³³³³³³³³³³³³³³³³³³', $3F, 0));
     Control^.GrowMode := gfGrowHiY;
     Insert(Control);

     R.Assign(74, 11, 79, 12);
     Control := New(PColoredText, Init(R, 'ÄÄÄÄÄ', $3F, 0));
     Insert(Control);

     R.Assign(62, 19, 73, 20);
     Control := New(PColoredText, Init(R, 'ÄÄÄÄÄÄÄÄÄÄÄ', $3F, 0));
     Insert(Control);

     R.Assign(74, 12, 77, 13);
     Control := New(PColoredText, Init(R, 'SP=', $30, 0));
     Insert(Control);

     R.Assign(74, 13, 77, 14);
     Control := New(PColoredText, Init(R, '-1=', $30, 0));
     Insert(Control);

     R.Assign(74, 14, 77, 15);
     Control := New(PColoredText, Init(R, '-2=', $30, 0));
     Insert(Control);

     R.Assign(74, 15, 77, 16);
     Control := New(PColoredText, Init(R, '-3=', $30, 0));
     Insert(Control);

     R.Assign(74, 16, 77, 17);
     Control := New(PColoredText, Init(R, '-4=', $30, 0));
     Insert(Control);

     R.Assign(74, 17, 77, 18);
     Control := New(PColoredText, Init(R, '-5=', $30, 0));
     Insert(Control);

     R.Assign(74, 18, 77, 19);
     Control := New(PColoredText, Init(R, '-6=', $30, 0));
     Insert(Control);

     R.Assign(74, 19, 77, 20);
     Control := New(PColoredText, Init(R, '-7=', $30, 0));
     Insert(Control);

     R.Assign(74, 20, 77, 21);
     Control := New(PColoredText, Init(R, '-8=', $30, 0));
     Insert(Control);

     R.Assign(74, 21, 77, 22);
     Control := New(PColoredText, Init(R, '-9=', $30, 0));
     Control^.GrowMode := gfGrowRel;
     Insert(Control);

     R.Assign(64, 1, 66, 2);
     RejestrACC := New(PColoredText, Init(R, '01', $3E, cmRejestrACC));
     Insert(RejestrACC);

     R.Assign(69, 1, 71, 2);
     RejestrB := New(PColoredText, Init(R, '02', $3E, cmRejestrB));
     Insert(RejestrB);

     R.Assign(67, 2, 71, 3);
     RejestrDPTR := New(PColoredText, Init(R, '0003', $3A, cmRejestrDPTR));
     Insert(RejestrDPTR);

     R.Assign(65, 3, 69, 4);
     RejestrPC := New(PColoredText, Init(R, '0004', $3A, cmRejestrPC));
     Insert(RejestrPC);

     R.Assign(65, 4, 67, 5);
     RejestrR0 := New(PColoredText, Init(R, '05', $34, cmRejestrR0));
     Insert(RejestrR0);

     R.Assign(65, 5, 67, 6);
     RejestrR2 := New(PColoredText, Init(R, '06', $34, cmRejestrR2));
     Insert(RejestrR2);

     R.Assign(65, 6, 67, 7);
     RejestrR4 := New(PColoredText, Init(R, '07', $34, cmRejestrR4));
     Insert(RejestrR4);

     R.Assign(65, 7, 67, 8);
     RejestrR6 := New(PColoredText, Init(R, '08', $34, cmRejestrR6));
     Insert(RejestrR6);

     R.Assign(71, 4, 73, 5);
     RejestrR1 := New(PColoredText, Init(R, '09', $34, cmRejestrR1));
     Insert(RejestrR1);

     R.Assign(71, 5, 73, 6);
     RejestrR3 := New(PColoredText, Init(R, '0a', $34, cmRejestrR3));
     Insert(RejestrR3);

     R.Assign(71, 6, 73, 7);
     RejestrR5 := New(PColoredText, Init(R, '0b', $34, cmRejestrR5));
     Insert(RejestrR5);

     R.Assign(71, 7, 73, 8);
     RejestrR7 := New(PColoredText, Init(R, '0c', $34, cmRejestrR7));
     Insert(RejestrR7);

     R.Assign(65, 8, 67, 9);
     PortP1 := New(PColoredText, Init(R, '0d', $31, cmPortP1));
     Insert(PortP1);

     R.Assign(71, 8, 73, 9);
     PortP3 := New(PColoredText, Init(R, '0e', $31, cmPortP3));
     Insert(PortP3);

     R.Assign(77, 12, 79, 13);
     WartoscSP := New(PColoredText, Init(R, '0f', $35, cmWartoscSP));
     Insert(WartoscSP);

     R.Assign(65, 9, 67, 10);
     RejestrSP := New(PColoredText, Init(R, '0g', $35, cmRejestrSP));
     Insert(RejestrSP);

     R.Assign(77, 13, 79, 14);
     WartoscSP1 := New(PColoredText, Init(R, '0h', $35, cmWartoscSP1));
     Insert(WartoscSP1);

     R.Assign(77, 14, 79, 15);
     WartoscSP2 := New(PColoredText, Init(R, '0i', $35, cmWartoscSP2));
     Insert(WartoscSP2);

     R.Assign(77, 15, 79, 16);
     WartoscSP3 := New(PColoredText, Init(R, '0j', $35, cmWartoscSP3));
     Insert(WartoscSP3);

     R.Assign(77, 16, 79, 17);
     WartoscSP4 := New(PColoredText, Init(R, '0k', $35, cmWartoscSP4));
     Insert(WartoscSP4);

     R.Assign(77, 17, 79, 18);
     WartoscSP5 := New(PColoredText, Init(R, '0l', $35, cmWartoscSP5));
     Insert(WartoscSP5);

     R.Assign(77, 18, 79, 19);
     WartoscSP6 := New(PColoredText, Init(R, '0m', $35, cmWartoscSP6));
     Insert(WartoscSP6);

     R.Assign(77, 19, 79, 20);
     WartoscSP7 := New(PColoredText, Init(R, '0n', $35, cmWartoscSP7));
     Insert(WartoscSP7);

     R.Assign(77, 20, 79, 21);
     WartoscSP8 := New(PColoredText, Init(R, '0o', $35, cmWartoscSP8));
     Insert(WartoscSP8);

     R.Assign(77, 21, 79, 22);
     WartoscSP9 := New(PColoredText, Init(R, '0p', $35, cmWartoscSP9));
     Insert(WartoscSP9);

     R.Assign(67, 13, 69, 14);
     RejestrSBUF := New(PColoredText, Init(R, '0q', $38, cmRejestrSBUF));
     Insert(RejestrSBUF);

     R.Assign(67, 12, 69, 13);
     RejestrTCON := New(PColoredText, Init(R, '0r', $3E, cmRejestrTCON));
     Insert(RejestrTCON);

     R.Assign(67, 14, 69, 15);
     RejestrSCON := New(PColoredText, Init(R, '0s', $3E, cmRejestrSCON));
     Insert(RejestrSCON);

     R.Assign(67, 15, 69, 16);
     RejestrPCON := New(PColoredText, Init(R, '0s', $3E, cmRejestrPCON));
     Insert(RejestrPCON);

     R.Assign(67, 16, 69, 17);
     RejestrTMOD := New(PColoredText, Init(R, '0s', $3E, cmRejestrTMOD));
     Insert(RejestrTMOD);

     R.Assign(65, 17, 67, 18);
     RejestrIE := New(PColoredText, Init(R, '0s', $3F, cmRejestrIE));
     Insert(RejestrIE);

     R.Assign(71, 17, 73, 18);
     RejestrIP := New(PColoredText, Init(R, '0s', $3F, cmRejestrIP));
     Insert(RejestrIP);

     R.Assign(65, 18, 73, 19);
     LiczbaCykli := New(PColoredText, Init(R, '12345678', $3F, cmLiczbaCykli));
     Insert(LiczbaCykli);


     R.Assign(65, 10, 69, 11);
     WartoscLicznikaT0 := New(PColoredText, Init(R, '000t', $36, cmWartoscLicznikaT0));
     Insert(WartoscLicznikaT0);

     R.Assign(65, 11, 69, 12);
     WartoscLicznikaT1 := New(PColoredText, Init(R, '000u', $36, cmWartoscLicznikaT1));
     Insert(WartoscLicznikaT1);

     R.Assign(62, 20, 66, 21);
     Control := New(PStaticText, Init(R, 'Int:'));
     Insert(Control);

     Inc(R.A.X, 4);  Inc(R.B.X, 2);
     PoziomLO := New(PColoredText, Init(R, 'lo', $30, cmPoziomLO));
     Insert(PoziomLO);

     Inc(R.A.X, 3);  Inc(R.B.X, 3);
     PoziomHI := New(PColoredText, Init(R, 'hi', $30, cmPoziomHI));
     Insert(PoziomHI);

     R.Assign(1, 1, 60, 22);
{     R.Grow(-1, -1);}
     PoleSledzeniaKodu := New(PPoleSledzeniaKodu, Init(R));
     Insert(PoleSledzeniaKodu);

     PoleSledzeniaKodu^.Select;


     UstawWartosciMonitoraRejestrow;
end;

destructor TOknoSledzenia.Done;
begin
     inherited Done;
     OknoCPU := nil;
end;