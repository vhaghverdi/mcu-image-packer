program mcu_image_packer;

{$mode objfpc}{$H+}{$J-}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces,
  {$IF Defined(Windows)}
  uDarkStyleParams,
  uMetaDarkStyle,
  uDarkStyleSchemes,
  {$ENDIF}
  Forms, Forms.Main, MCUImage;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='MCU Image Packer';
  Application.Scaled:=True;
  {$IF Defined(Windows)}
  PreferredAppMode:=pamAllowDark;
  uMetaDarkStyle.ApplyMetaDarkStyle(DefaultDark);
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

