unit Forms.Main;

{$mode objfpc}{$H+}{$J-}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, Clipbrd, StrUtils, MCUImage;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnCopy:          TBitBtn;
    edtPath:          TEdit;
    gbInfo:           TGroupBox;
    gbSettings:       TGroupBox;
    imgMain:          TImage;
    lblDropImage:     TLabel;
    lblImageTypes:    TLabel;
    lblPath:          TLabel;
    lblImgCount:      TLabel;
    lblWidth:         TLabel;
    lblHeight:        TLabel;
    lblImgCountValue: TLabel;
    lblWidthValue:    TLabel;
    lblHeightValue:   TLabel;
    memOutput:        TMemo;
    pnlImage:         TPanel;
    pnlOutput:        TPanel;
    pnlInfo:          TPanel;
    pnlSettings:      TPanel;
    rgDataType:       TRadioGroup;
    rgRepresentation: TRadioGroup;
    rgLayout:         TRadioGroup;
    procedure btnCopyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure rgDataTypeSelectionChanged(Sender: TObject);
    procedure rgLayoutSelectionChanged(Sender: TObject);
    procedure rgRepresentationSelectionChanged(Sender: TObject);

    procedure UpdateOutput;
  end;

var
  frmMain:      TfrmMain;
  MCUImageList: TMCUImageList;

const
  APP_NAME    = 'MCU Image Packer';
  APP_VERSION = '[pre-release build]';

implementation

{$R *.lfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption      := APP_NAME + ' ' + APP_VERSION;
  MCUImageList := TMCUImageList.Create;
end;

procedure TfrmMain.FormDropFiles(Sender: TObject;
  const FileNames: array of string);
var
  MCUImage: TMCUImage;
begin
  lblDropImage.Visible  := False;
  lblImageTypes.Visible := False;
  MCUImageList.Clear;
  MCUImage := TMCUImage.Create(FileNames[0]);
  MCUImageList.Add(MCUImage);
  imgMain.Picture.Assign(MCUImage.Picture);
  edtPath.Text             := MCUImage.Path;
  lblImgCountValue.Caption := IntToStr(MCUImageList.Count);
  lblWidthValue.Caption    := IntToStr(MCUImage.Picture.Width);
  lblHeightValue.Caption   := IntToStr(MCUImage.Picture.Height);
  UpdateOutput;
end;

procedure TfrmMain.rgDataTypeSelectionChanged(Sender: TObject);
begin
  UpdateOutput;
end;

procedure TfrmMain.rgLayoutSelectionChanged(Sender: TObject);
begin
  UpdateOutput;
end;

procedure TfrmMain.rgRepresentationSelectionChanged(Sender: TObject);
begin
  UpdateOutput;
end;

procedure TfrmMain.UpdateOutput;
begin
  memOutput.Text := CanvasToStr(imgMain.Picture.Bitmap,
    TRepresentationType(rgRepresentation.ItemIndex),
    TArrayLayout(rgLayout.ItemIndex), TDataType(rgDataType.ItemIndex));
end;

procedure TfrmMain.btnCopyClick(Sender: TObject);
begin
  Clipboard.AsText := memOutput.Text;
end;

end.
