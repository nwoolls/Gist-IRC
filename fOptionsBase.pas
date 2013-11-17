unit fOptionsBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TOptionsBaseFrame = class(TFrame)
  public
    function Save: Boolean; virtual;
    procedure Load; virtual;
  end;

  TOptionsBaseFrameClass = class of TOptionsBaseFrame;

implementation

{$R *.dfm}

{ TOptionsBaseFrame }

procedure TOptionsBaseFrame.Load;
begin

end;

function TOptionsBaseFrame.Save: Boolean;
begin
  Result := True;
end;

end.
