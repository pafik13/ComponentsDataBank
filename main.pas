unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, pqconnection, sqldb, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, Grids, Menus, ComCtrls, DBGrids, db, miCL,
  clTreeNode, clCommon, _fHelp, _fQueryConditions;

type

  { TForm1 }

  TForm1 = class(TForm)
    dsQuery: TDatasource;
    miSelect: TMenuItem;
    miSearch: TMenuItem;
    miHelp: TMenuItem;
    miAbout: TMenuItem;
    miClass: TMenuItem;
    miStComp: TMenuItem;
    miAdmin: TMenuItem;
    miShowClassifier: TMenuItem;
    mmMain: TMainMenu;
    miClassifier: TMenuItem;
    pmClass: TPopupMenu;
    PQConnection: TPQConnection;
    SQLQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    tvClassifier: TTreeView;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure miClassClick(Sender: TObject);
    procedure miClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure miSelectClick(Sender: TObject);
    procedure miShowClassifierClick(Sender: TObject);
    procedure miStCompClick(Sender: TObject);
    procedure PQConnectionAfterConnect(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure tvClassifierSelectionChanged(Sender: TObject);
  private
    { private declarations }
    FTCD: TTreeDataCollection;
    function getTreeRoots(): TStringList;
    function findSubMenu(path:String): TMenuItemCL;
    function findParent(subPath: String): TTreeNodeCL;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.tbRefreshClick(Sender: TObject);
var
  pNode: TTreeNode;
  path, subPath, store, pName: String;
  i: Integer;
begin
  pNode := nil;
  SQLQuery.Open;
  FTCD.Clear();
  i := FTCD.Count;
  SQLQuery.First;
  while not SQLQuery.EOF do
  begin
    path    := SQLQuery.FieldByName('path').AsString;
    subPath := Copy(path, 1, LastDelimiter('.', path) - 1);
    store   := SQLQuery.FieldByName('store').AsString;
    pname   := path + ' ' + SQLQuery.FieldByName('cl_name').AsString;

    if subPath = '' then
      tvClassifier.Items.AddObject(nil, pname, FTCD.Add(path, subPath, store))
    else
      begin
        pNode := tvClassifier.Items.FindNodeWithData(FTCD.FindItem(subPath));
        if Assigned(pNode) then
          tvClassifier.Items.AddChildObject(pNode, pname, FTCD.Add(path, subPath, store))
        else
          ShowMessage('Cannot find a subpath: ' + subpath);
      end;

    SQLQuery.Next;
  end;
  ShowMessage ('Init  : ' + IntToStr(i)  + char(#10) +
               'Rec   : ' + IntToStr(SQLQuery.RecordCount) + char(#10) +
               'Final : ' + IntToStr(FTCD.Count) + char(#10)
              );
end;

procedure TForm1.tvClassifierSelectionChanged(Sender: TObject);
//begin
var
  node: TTreeNode;
begin
 // tvClassifier.Selected.Data:=;
  //if not (Sender is TTreeView) then
  //  Exit
  //else
  //  node := tvClassifier.Selected;
  //ShowMessage('Level:     ' + IntToStr(node.Index)          + Char(#10) +
  //            'Height:    ' + IntToStr(node.Height)         + Char(#10) +
  //            'Path:      ' + TTreeData(node.Data^).Path    + Char(#10) +
  //            'SubPath:   ' + TTreeData(node.Data^).SubPath + Char(#10) +
  //            'Store:     ' + TTreeData(node.Data^).Store
  //           );
end;

function TForm1.getTreeRoots: TStringList;
var
  Roots: TStringList;
begin
  Roots := TStringList.Create;
  try
    with SQLQuery do
    begin
      SQL.Text := 'select "id", "name", "tree"::varchar(50) as tree  from "world" where nlevel("tree") = ''1''';
      Open;
      while not EOF do
      begin
        Roots.Add(FieldByName('name').AsString);
        Next;
      end;
    end;
  except
    Roots.Free;
  end;
  Result := Roots;
end;

function TForm1.findSubMenu(path: String): TMenuItemCL;
var
  pos, i, j: Integer;
  paths: TStringList;
begin
  Result := nil;
  paths := TStringList.Create();
  pos := AnsiPos('.', path);
  while pos <> 0 do
  begin
    paths.Add(Copy(path, 1, pos-1));
    Delete(path, 1, pos);
    pos := AnsiPos('.', path);
  end;
  for i:= 0 to paths.Count - 1 do
  begin
    if i = 0 then
      begin
        for j:= 0 to mmMain.Items[0].Count - 1 do
        begin
          if TMenuItemCL(mmMain.Items[0].Items[j]).SubPath = paths.Strings[i] then
          begin
            Result := TMenuItemCL(mmMain.Items[0].Items[j]);
            Break;
          end;
        end;
      end
    else
      begin
        for j:= 0 to Result.Count - 1 do
        begin
          if TMenuItemCL(Result.Items[j]).SubPath = paths.Strings[i] then
          begin
            Result := TMenuItemCL(Result.Items[j]);
            Exit;
          end;
        end;
      end
  end;
end;

function TForm1.findParent(subPath: String): TTreeNodeCL;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to tvClassifier.Items.Count - 1 do
    if TTreeNodeCL(tvClassifier.Items[i]).SubPath = subPath then
    begin
      Result := TTreeNodeCL(tvClassifier.Items[i]);
      Exit;
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SQLQuery.Close;
  FTCD.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  inherited;
  FTCD := TTreeDataCollection.Create(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  pNode: TTreeNode;
  path, subPath, store, pName: String;
  i: Integer;
begin
  pNode := nil;
  SQLQuery.Open;
  FTCD.Clear();
  i := FTCD.Count;
  SQLQuery.First;
  while not SQLQuery.EOF do
  begin
    path    := SQLQuery.FieldByName('path').AsString;
    subPath := Copy(path, 1, LastDelimiter('.', path) - 1);
    store   := SQLQuery.FieldByName('store').AsString;
    pname   := path + ' ' + SQLQuery.FieldByName('cl_name').AsString;

    if subPath = '' then
      tvClassifier.Items.AddObject(nil, pname, FTCD.Add(path, subPath, store))
    else
      begin
        pNode := tvClassifier.Items.FindNodeWithData(FTCD.FindItem(subPath));
        if Assigned(pNode) then
          tvClassifier.Items.AddChildObject(pNode, pname, FTCD.Add(path, subPath, store))
        else
          ShowMessage('Cannot find a subpath: ' + subpath);
      end;

    SQLQuery.Next;
  end;
end;

procedure TForm1.miClassClick(Sender: TObject);
begin
end;

procedure TForm1.miClick(Sender: TObject);
begin
  ShowMessage(TMenuItemCL(Sender).Path);
end;

procedure TForm1.miHelpClick(Sender: TObject);
var
  form: TfHelp;
begin
  form := TfHelp.Create(Self);
  form.Show;
end;

procedure TForm1.miSelectClick(Sender: TObject);
//begin
var
  node: TTreeNode;
  td: TTreeData;
  fQ: TfQueryConditions;
begin
  node := tvClassifier.Selected;
  td := FTCD.Items[node.AbsoluteIndex];
  if not Assigned(td) then
    Exit;
//
//  ShowMessage('Level:     ' + IntToStr(node.Index)          + Char(#10) +
//              'Height:    ' + IntToStr(node.Height)         + Char(#10) +
//              'Path:      ' + td.Path    + Char(#10) +
//              'SubPath:   ' + td.SubPath + Char(#10) +
//              'Store:     ' + td.Store
//             );

  fQ := TfQueryConditions.Create(Self);
  fQ.SetStoreTable('tbl_' + td.Store);

  fQ.Show;
end;

procedure TForm1.miShowClassifierClick(Sender: TObject);
begin
  if tvClassifier.Visible then begin
    miShowClassifier.Caption:= 'Показать';
    tvClassifier.Visible := False;
  end else begin
    miShowClassifier.Caption:= 'Скрыть';
    tvClassifier.Visible := True;
  end;
end;

procedure TForm1.miStCompClick(Sender: TObject);
begin

end;

procedure TForm1.PQConnectionAfterConnect(Sender: TObject);
begin

end;

end.

