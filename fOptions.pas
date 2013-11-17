unit fOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

type
  TOptionsForm = class(TForm)
    CancelButton: TButton;
    OkButton: TButton;
    PagesList: TListView;
    HolderPanel: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PagesListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
  private
    procedure LoadPages;
    procedure SaveChanges;
  end;

implementation

uses fOptionsBase, fIdentificationOptions;

type
  TOptionPage = record
    Caption: string;
    FrameClass: TOptionsBaseFrameClass;
    Frame: TOptionsBaseFrame;
  end;

const
  OptionPages: array [0..0] of TOptionPage = (
    (Caption: 'Identification'; FrameClass: TIdentificationOptionsFrame)
  );

{$R *.dfm}

procedure TOptionsForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(OptionPages) to High(OptionPages) do
    OptionPages[I].Frame := nil;
end;

procedure TOptionsForm.OkButtonClick(Sender: TObject);
begin
  SaveChanges;
end;

procedure TOptionsForm.SaveChanges;
var
  I: Integer;
begin
  for I := Low(OptionPages) to High(OptionPages) do
  begin
    if Assigned(OptionPages[I].Frame) then
    begin
      if not OptionPages[I].Frame.Save then
      begin
        PagesList.ItemIndex := I;
        Exit;
      end;
    end;
  end;
  ModalResult := mrOk;
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
begin
  LoadPages;
end;

procedure TOptionsForm.LoadPages;
var
  I: Integer;
begin
  for I := Low(OptionPages) to High(OptionPages) do
  begin
    PagesList.Items.Add.Caption := OptionPages[I].Caption;
  end;
  PagesList.Items[0].Selected := True;
end;

procedure TOptionsForm.PagesListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if (Change = ctState) and Item.Selected then
  begin
    if not Assigned(OptionPages[Item.Index].Frame) then
    begin
      OptionPages[Item.Index].Frame := OptionPages[Item.Index].FrameClass.Create(Self);
      OptionPages[Item.Index].Frame.Align := alClient;
      OptionPages[Item.Index].Frame.Load;
      OptionPages[Item.Index].Frame.Parent := HolderPanel;
    end;
    OptionPages[Item.Index].Frame.BringToFront;
  end;
end;

end.
