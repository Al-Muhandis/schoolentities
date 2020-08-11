unit SchoolEntities;

{$mode objfpc}{$H+}
{$interfaces corba}

interface

uses
  Classes, SysUtils;

type
  TEntityType = (seRoot, seUser, seCourse, seLesson, seSlide, seInvitation, seSession,
    seStudentSpot, seStudent, seTeacher, seUnknown);

  TUser = class;
  TCourse = class;
  TLesson = class;

  { IORMInterface }

  IORMInterface = interface ['{1CCA5072-5A35-4FAC-9E06-D65E7A5BBE94}']
    function GetUser(aUser: TUser): Boolean;                 
    function GetCourse(aCourse: TCOurse): Boolean;
    function GetLesson(aLesson: TLesson): Boolean;
  end;

  { TSchoolElement }

  TSchoolElement = class(TPersistent)
  private
    FName: String;
    FORM: IORMInterface; // CoursesDB
    FTeacher: Int64;
    function GetName: String;
    procedure Initiate; virtual;
    procedure SetName(AValue: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetID64: Int64; virtual; abstract;
    procedure SetID64(AValue: Int64); virtual; abstract;
  public
    class function EntityAlias: String;
    class function EntityType: TEntityType; virtual;
    property ORM: IORMInterface read FORM write FORM;
    property Name: String read GetName write SetName;
    property ID64: Int64 read GetID64 write SetID64;
    property Teacher: Int64 read FTeacher write FTeacher;
  end;
  TSchoolElementClass = class of TSchoolElement;

  { TUser }

  TUser = class(TSchoolElement)
  private
    Fid: Int64;
    FLang: String;
    FSession: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetID64: Int64; override;
    procedure SetID64(AValue: Int64); override;
  public
    constructor Create;
    class function EntityType: TEntityType; override;
    procedure Initiate; override;
  published
    property id: Int64 read Fid write Fid;
    property Lang: String read FLang write FLang;
    property Name;
    property Session: Integer read FSession write FSession;
  end;


  TContentType = (stText, stPhoto, stVideo, stAudio, stVoice, stDocument, stUnknown);

  { TCourseElement }

  TCourseElement = class(TSchoolElement)
  private
    Fid: Integer;
    FInteractive: Boolean;
    FMedia: String;
    FMediaType: Byte;
    FText: String;
    function GetMediaType: TContentType;
    procedure SetMediaType(AValue: TContentType);
  protected
    protected procedure AssignTo(Dest: TPersistent); override;
    function GetID64: Int64; override;
    procedure SetID64(AValue: Int64); override;
  public
    class function EntityType: TEntityType; override;
    function GetParentID: Int64; virtual; abstract;
    procedure Initiate; override;
    property MediaType: TContentType read GetMediaType write SetMediaType;
  published
    property Name;
    property id: Integer read Fid write Fid;
    property Interactive: Boolean read FInteractive write FInteractive;
    property Media: String read FMedia write FMedia;
    property Media_Type: Byte read FMediaType write FMediaType;
    property Text: String read FText write FText;
  end;

  TLicType=(ltOpen, ltPublic, ltPrivate);
  TUserStatus=(usNone, usStudent, usTeacher, usUnknown);

  { TCourse }

  TCourse = class(TCourseElement)
  private
    FContact: String;
    FHistoryChat: String;
    FOwner: Int64;
    FShowContact: Boolean;
    FTesting: Boolean;
    FVisibility: Integer;
    function GetLicType: TLicType;
    procedure SetLicType(AValue: TLicType);
  protected
    protected procedure AssignTo(Dest: TPersistent); override;
  public
    class function EntityType: TEntityType; override;
    function GetParentID: Int64; override;
    procedure Initiate; override;
    property LicType: TLicType read GetLicType write SetLicType;
  published
    property Owner: Int64 read FOwner write FOwner;
    property Visibility: Integer read FVisibility write FVisibility;
    property Contact: String read FContact write FContact;
    property ShowContact: Boolean read FShowContact write FShowContact;
    property Testing: Boolean read FTesting write FTesting;
    property Teacher;
    property HistoryChat: String read FHistoryChat write FHistoryChat;
  end;

  { TLesson }

  TLesson = class(TCourseElement)
  private
    FCourse: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function GetParentID: Int64; override;
    procedure Initiate; override;
    class function EntityType: TEntityType; override;
  published
    property Course: Integer read FCourse write FCourse;
  end;

  { TSlide }

  TSlide = class(TCourseElement)
  private
    FLesson: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    class function EntityType: TEntityType; override;
    function GetParentID: Int64; override;
    procedure Initiate; override;
  published
    property Lesson: Integer read FLesson write FLesson;
  end;

  { TInvitation }

  TInvitation = class(TSchoolElement)
  private
    FApplied: Integer;
    FCapacity: Integer;
    FCourse: Integer;
    FID: Integer;
    FStatus: Integer;
    function GetUserStatus: TUserStatus;
    procedure SetUserStatus(AValue: TUserStatus);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetID64: Int64; override;
    procedure SetID64(AValue: Int64); override;
  public
    procedure Initiate; override;
    class function EntityType: TEntityType; override;
    property UserStatus: TUserStatus read GetUserStatus write SetUserStatus;
  published
    property ID: Integer read FID write FID;
    property Applied: Integer read FApplied write FApplied;
    property Capacity: Integer read FCapacity write FCapacity;
    property Course: Integer read FCourse write FCourse;
    property Status: Integer read FStatus write FStatus;
    property Teacher;
  end;

  { TStudentSpot }

  TStudentSpot = class(TSchoolElement)
  private
    FCourse: Integer;
    FID: Integer;
    FLesson: Integer;
    FStatus: Integer;
    FUser: Int64;
    F_Course: TCourse;
    F_Lesson: TLesson;
    F_User: TUser;
    function GetUserStatus: TUserStatus;
    function Get_Course: TCourse;
    function Get_Lesson: TLesson;
    function Get_User: TUser;
    procedure SetUserStatus(AValue: TUserStatus);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetID64: Int64; override;
    procedure SetID64(AValue: Int64); override;
  public
    destructor Destroy; override;
    procedure Initiate; override;
    property UserStatus: TUserStatus read GetUserStatus write SetUserStatus;
    property _User: TUser read Get_User;
    property _Lesson: TLesson read Get_Lesson;
    property _Course: TCourse read Get_Course;
  published
    property ID: Integer read FID write FID;
    property User: Int64 read FUser write FUser;
    property Course: Integer read FCourse write FCourse;
    property Status: Integer read FStatus write FStatus;
    property Teacher;
    property Lesson: Integer read FLesson write FLesson;
  end;

  { TSession }

  TSession = class(TSchoolElement)
  private
    FEntity: String;
    FEntityID: Integer;
    FID: Integer;
    FStudent: Int64;
  protected
    function GetID64: Int64; override;
    procedure SetID64(AValue: Int64); override;
  public
    procedure AssignTo(Dest: TPersistent); override;
    procedure Initiate; override;
    function GetSourceEntityType: TEntityType;
    class function EntityType: TEntityType; override;
  published
    property ID: Integer read FID write FID;
    property SourceEntity: String read FEntity write FEntity;
    property EntityID: Integer read FEntityID write FEntityID;
    property Student: Int64 read FStudent write FStudent;
    property Teacher;
  end;

function EntityFromString(const aAlias: String): TEntityType;
function EntityTypeToString(aEntity: TEntityType): String;
function CaptionFromSchEntity(aEntity: TEntityType; Multiple: Boolean = False): String;
function LicTypeToCaption(const aLicType: TLicType): String;
function StringToUserStatus(const aAlias: String): TUserStatus;
function UserStatusToString(const aUserStatus: TUserStatus): String;

resourcestring
  s_Users='Users';
  s_Courses='Courses';
  s_Lessons='Lessons';
  s_Slides='Slides';
  s_Invitations='Invitations';
  s_ContactUs='Contact us';
  s_User='User';
  s_Course='Course';
  s_Lesson='Lesson';
  s_Slide='Slide';
  s_Invitation='Invitation';
  s_NotFound='Not found or no access!';
  s_NotPassed='You have not passed the previous lesson';
  s_AppliedFromAll='Applied %1d of %2d';
  s_Public='Public';
  s_Private='Private';
  s_OpenSource='OpenSource';
  s_TestOrAsk='Test / Ask the teacher';
  s_Session='Dialogue';
  s_Sessions='Dialogues';
  s_Student='Student';
  s_Students='Students';
  s_Teacher='Teacher';
  s_Teachers='Teachers'; 
  s_HistoryChat='History chat';
  s_GotMsg='You got a message';
  s_WroteMsg='wrote you a message';
  s_DYWntEntrDlg='Do you want to enter into a dialogue with him?';
  s_YStudent='You are a student of the following courses';
  s_YTeacher='You are a teacher of the following courses'; 
  s_TakeCourses='Take courses'; 
  s_TeachCourses='Teach courses';

var
  SchoolClasses: array[TEntityType] of TSchoolElementClass =
    (TSchoolElement, TUser, TCourse, TLesson, TSlide, TInvitation, TSession, TStudentSpot,
    TStudentSpot, TStudentSpot, TSchoolElement);

implementation

uses
  strutils
  ;

var
  SchoolEntityNames: array[TEntityType] of String =
    ('root', 'user', 'course', 'lesson', 'slide', 'invitation', 'session', 'spot', 'student',
      'teacher', '');
  UserStatusNames: array[TUserStatus] of String =('none', 'student', 'teacher', '');

function LicTypeToCaption(const aLicType: TLicType): String;
begin
  Result:=EmptyStr;
  case aLicType of
    ltOpen:       Result:=s_OpenSource;
    ltPublic:     Result:=s_Public;
    ltPrivate:    Result:=s_Private;
  end;
end;

function StringToUserStatus(const aAlias: String): TUserStatus;
begin
  Result:=TUserStatus(AnsiIndexStr(aAlias, UserStatusNames));
end;

function UserStatusToString(const aUserStatus: TUserStatus): String;
begin
  Result:=UserStatusNames[aUserStatus];
end;

function EntityFromString(const aAlias: String): TEntityType;
var
  i: Integer;
begin
  i:=AnsiIndexStr(aAlias, SchoolEntityNames);
  case i of
    0..Ord(High(TEntityType)): Result:=TEntityType(i);
  else
    Result:=seUnknown;
  end;
end;

function EntityTypeToString(aEntity: TEntityType): String;
begin
  Result:=SchoolEntityNames[aEntity];
end;


function CaptionFromSchEntity(aEntity: TEntityType; Multiple: Boolean = False): String;
begin
  if Multiple then
    case aEntity of
      seUser:       Result:=s_Users;
      seCourse:     Result:=s_Courses;
      seLesson:     Result:=s_Lessons;
      seSlide:      Result:=s_Slides;
      seInvitation: Result:=s_Invitations;
      seSession:    Result:=s_Sessions;
      seStudentSpot: Result:= s_Students;
      seStudent:     Result:=s_Students;
      seTeacher:    Result:=s_Teachers;
    else
      Result:=EmptyStr;
    end
  else
    case aEntity of
      seUser:       Result:=s_User;
      seCourse:     Result:=s_Course;
      seLesson:     Result:=s_Lesson;
      seSlide:      Result:=s_Slide;
      seInvitation: Result:=s_Invitation;
      seSession:    Result:=s_Session;
      seStudentSpot: Result:=s_Student;
      seStudent:     Result:=s_Student;
      seTeacher:    Result:=s_Teacher;
    else
      Result:=EmptyStr;
    end;
end;

{ TSession }

function TSession.GetID64: Int64;
begin
  Result:=FID;
end;

procedure TSession.SetID64(AValue: Int64);
begin
  FID:=AValue;
end;

procedure TSession.AssignTo(Dest: TPersistent);
var
  aDest: TSession;
begin
  inherited AssignTo(Dest);
  if not (Dest is TSession) then
    Exit;
  aDest:=TSession(Dest);
  aDest.FStudent:=FStudent;
  aDest.FEntity:=FEntity;
  aDest.FEntityID:=FEntityID;
end;

procedure TSession.Initiate;
begin
  inherited Initiate;
  FEntity:=EmptyStr;
  FEntityID:=0;
  FStudent:=0;
end;

function TSession.GetSourceEntityType: TEntityType;
begin
  Result:=EntityFromString(FEntity);
end;

class function TSession.EntityType: TEntityType;
begin
  Result:=seSession;
end;

{ TStudentSpot }

function TStudentSpot.GetUserStatus: TUserStatus;
begin
  Result:=TUserStatus(FStatus);
end;

function TStudentSpot.Get_Course: TCourse;
begin
  if not Assigned(FORM) then
    Exit(nil);
  if not Assigned(F_Course) then
    F_Course:=TCourse.Create;
  if F_Course.id<>FCourse then
  begin
    F_Course.id:=FCourse;
    FORM.GetCourse(F_Course);
  end;
  Result:=F_Course;
end;

function TStudentSpot.Get_Lesson: TLesson;
begin
  if not Assigned(FORM) then
    Exit(nil);
  if not Assigned(F_Lesson) then
    F_Lesson:=TLesson.Create;
  if F_Lesson.id<>FLesson then
  begin
    F_Lesson.id:=FLesson;
    FORM.GetLesson(F_Lesson);
  end;
  Result:=F_Lesson;
end;

function TStudentSpot.Get_User: TUser;
begin
  if not Assigned(FORM) then
    Exit(nil);
  if not Assigned(F_User) then
    F_User:=TUser.Create;
  if F_User.id<>FUser then
  begin
    F_User.id:=FUser;
    FORM.GetUser(F_User);
  end;
  Result:=F_User;
end;

procedure TStudentSpot.SetUserStatus(AValue: TUserStatus);
begin
  FStatus:=Ord(AValue);
end;

procedure TStudentSpot.AssignTo(Dest: TPersistent);
var
  aDest: TStudentSpot;
begin
  inherited AssignTo(Dest);
  if not (Dest is TStudentSpot) then
    Exit;
  aDest:=TStudentSpot(Dest);
  aDest.FUser:=FUser;
  aDest.FCourse:=FCourse;
  aDest.FStatus:=FStatus;
  aDest.FLesson:=FLesson;
end;

function TStudentSpot.GetID64: Int64;
begin
  Result:=FID;
end;

procedure TStudentSpot.SetID64(AValue: Int64);
begin
  FID:=AValue;
end;

destructor TStudentSpot.Destroy;
begin
  F_User.Free;
  inherited Destroy;
end;

procedure TStudentSpot.Initiate;
begin
  inherited Initiate;
  FUser:=0;
  FCourse:=0;
  UserStatus:=usNone;
  FLesson:=0;
end;

{ TInvitation }

function TInvitation.GetUserStatus: TUserStatus;
begin
  Result:=TUserStatus(FStatus);
end;

procedure TInvitation.SetUserStatus(AValue: TUserStatus);
begin
  FStatus:=Ord(AValue);
end;

procedure TInvitation.AssignTo(Dest: TPersistent);
var
  aDest: TInvitation;
begin
  inherited AssignTo(Dest);
  if not (Dest is TInvitation) then
    Exit;
  aDest:=TInvitation(Dest);
  aDest.FApplied:=FApplied;
  aDest.FCapacity:=FCapacity;
  aDest.FCourse:=FCourse;
  aDest.FStatus:=FStatus;
end;

function TInvitation.GetID64: Int64;
begin
  Result:=FID;
end;

procedure TInvitation.SetID64(AValue: Int64);
begin
  FID:=AValue;
end;

procedure TInvitation.Initiate;
begin
  inherited Initiate;
  FCapacity:=0;
  FApplied:=0;
  FCourse:=0;
  UserStatus:=usStudent;
end;

class function TInvitation.EntityType: TEntityType;
begin
  Result:=seInvitation;
end;

{ TSlide }

procedure TSlide.Initiate;
begin
  inherited;
  FLesson:=0;
  FInteractive:=True;
end;

procedure TSlide.AssignTo(Dest: TPersistent);
var
  aDest: TSlide;
begin
  inherited AssignTo(Dest);
  if not (Dest is TSlide) then
    Exit;
  aDest:=TSlide(Dest);
  aDest.FLesson:=FLesson;
end;

class function TSlide.EntityType: TEntityType;
begin
  Result:=seSlide;
end;

function TSlide.GetParentID: Int64;
begin
  Result:=FLesson;
end;

{ TLesson }

procedure TLesson.AssignTo(Dest: TPersistent);
var
  aDest: TLesson;
begin
  inherited AssignTo(Dest);
  if not (Dest is TLesson) then
    Exit;
  aDest:=TLesson(Dest);
  aDest.FCourse:=FCourse;
end;

function TLesson.GetParentID: Int64;
begin
  Result:=FCourse;
end;

procedure TLesson.Initiate;
begin
  inherited;
  FCourse:=0;
end;

class function TLesson.EntityType: TEntityType;
begin
  Result:=seLesson;
end;

{ TCourse }

function TCourse.GetLicType: TLicType;
begin
  Result:=TLicType(FVisibility);
end;

procedure TCourse.SetLicType(AValue: TLicType);
begin
  FVisibility:=Ord(AValue);
end;

procedure TCourse.AssignTo(Dest: TPersistent);
var
  aDest: TCourse;
begin
  inherited AssignTo(Dest);
  if not (Dest is TCourse) then
    Exit;
  aDest:=TCourse(Dest);
  aDest.FContact:=FContact;
  aDest.FOwner:=FOwner;
  aDest.FShowContact:=FShowContact;
  aDest.FVisibility:=FVisibility;
  aDest.FTesting:=FTesting;
  aDest.HistoryChat:=FHistoryChat;
end;

class function TCourse.EntityType: TEntityType;
begin
  Result:=seCourse;
end;

function TCourse.GetParentID: Int64;
begin
  Result:=FOwner;
end;

procedure TCourse.Initiate;
begin
  inherited;
  FOwner:=0;
  FVisibility:=0;
  FContact:=EmptyStr;
  FTesting:=False;
  FHistoryChat:=EmptyStr;
end;

{ TCourseElement }

function TCourseElement.GetMediaType: TContentType;
begin
  Result:=TContentType(FMediaType);
end;

procedure TCourseElement.SetMediaType(AValue: TContentType);
begin
  FMediaType:=Ord(AValue);
end;

procedure TCourseElement.AssignTo(Dest: TPersistent);
var
  aDest: TCourseElement;
begin
  inherited AssignTo(Dest);
  if not (Dest is TCourseElement) then
    Exit;
  aDest:=TCourseElement(Dest);
  aDest.FInteractive:=FInteractive;
  aDest.FMedia:=FMedia;
  aDest.FMediaType:=FMediaType;
  aDest.FText:=FText;
end;

function TCourseElement.GetID64: Int64;
begin
  Result:=Fid;
end;

procedure TCourseElement.SetID64(AValue: Int64);
begin
  Fid:=AValue;
end;

class function TCourseElement.EntityType: TEntityType;
begin
  Result:=seCourse;
end;

procedure TCourseElement.Initiate;
begin
  inherited Initiate;
  FInteractive:=False;
  FMedia:=EmptyStr;
  FMediaType:=0;
  FText:=EmptyStr;
end;

{ TSchoolElement }

function TSchoolElement.GetName: String;
begin
  if FName<>EmptyStr then
    Result:=FName
  else begin
    Result:=ClassName;
    Removeleadingchars(Result, ['T', 't']);
  end;
end;

procedure TSchoolElement.Initiate;
begin
  FName:=EmptyStr;
  FTeacher:=0;
end;

procedure TSchoolElement.SetName(AValue: String);
begin
  FName:=AValue;
end;

procedure TSchoolElement.AssignTo(Dest: TPersistent);
begin
  if not (Dest is TSchoolElement) then
  begin
    inherited AssignTo(Dest);
    Exit;
  end;
  TSchoolElement(Dest).FName:=FName;
  TSchoolElement(Dest).FTeacher:=FTeacher;
end;

class function TSchoolElement.EntityAlias: String;
begin
  Result:=SchoolEntityNames[EntityType];
end;

class function TSchoolElement.EntityType: TEntityType;
begin
  Result:=seUnknown;
end;

{ TUser }

procedure TUser.AssignTo(Dest: TPersistent);
var
  aDest: TUser;
begin
  inherited AssignTo(Dest);
  if not (Dest is TUser) then
    Exit
  else begin
    aDest:=TUser(Dest);
    aDest.FLang:=FLang;
    aDest.FSession:=FSession;
  end;
end;

function TUser.GetID64: Int64;
begin
  Result:=Fid;
end;

procedure TUser.SetID64(AValue: Int64);
begin
  Fid:=AValue;
end;

constructor TUser.Create;
begin
  Initiate;
end;

class function TUser.EntityType: TEntityType;
begin
  Result:=seUser;
end;

procedure TUser.Initiate;
begin
  inherited;
  FLang:='ru';
  FSession:=0;
end;

end.

