unit clTreeNode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls;

type

  { TTreeNodeCL }

  TTreeNodeCL = class(TTreeNode)
  protected
    FSubPath: String;
    FPath   : String;
  public
    property SubPath: String read FSubPath write FSubPath;
    property Path: String read FPath write FPath;
  end;
implementation

end.

