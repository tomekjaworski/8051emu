function ZdarzeniaEdytora(Dialog: Integer; Info: Pointer): Word;
var
  R: TRect;
  T: TPoint;
begin
  case Dialog of
    edOutOfMemory: ZdarzeniaEdytora := MessageBox('Zbyt maˆo pami©ci do wykonania tej operacji.',
                                                  nil, mfError + mfOkButton);
    edReadError: ZdarzeniaEdytora := MessageBox('Bˆ¥d podczas odczytu pliku %s.', @Info, mfError + mfOkButton);
    edWriteError: ZdarzeniaEdytora := MessageBox('Bˆ¥d poczas zapisu pliku%s.', @Info, mfError + mfOkButton);
    edCreateError: ZdarzeniaEdytora := MessageBox('Bˆ¥d podczas tworzenia pliku %s.', @Info, mfError + mfOkButton);
    edSaveModify: ZdarzeniaEdytora := MessageBox('%s zostaˆ zmodyfikowany. Zapisa†?', @Info, mfConfirmation + mfYesNoCancel);
    edSaveUntitled: ZdarzeniaEdytora := MessageBox('Zapisa† plik beznazwy?', nil, mfConfirmation + mfYesNoCancel);
    edSaveAs: ZdarzeniaEdytora := Application^.ExecuteDialog(New(PFileDialog, Init('*.ASM',
                                  'Zapisz jako', '~N~azwa:', fdOkButton, 101)), Info);
    edFind: ZdarzeniaEdytora := Application^.ExecuteDialog(MakeSzukajDlg, Info);
    edSearchFailed:  ZdarzeniaEdytora := MessageBox('Zadany ci¥g znak¢w nie zostaˆ znaleziony.',
                                         nil, mfError + mfOkButton);
    edReplace:
      ZdarzeniaEdytora := Application^.ExecuteDialog(MakeZastapDlg, Info);
    edReplacePrompt:
      begin
        R.Assign(0, 1, 40, 8);
        R.Move((Desktop^.Size.X - R.B.X) div 2, 0);
        Desktop^.MakeGlobal(R.B, T);
        Inc(T.Y);
        if TPoint(Info).Y <= T.Y then
          R.Move(0, Desktop^.Size.Y - R.B.Y - 2);
        ZdarzeniaEdytora := MessageBoxRect(R, 'Zast¥pi† ten tekst?',
          nil, mfYesNoCancel + mfInformation);
      end;
  end;
end;

