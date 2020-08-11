unit opcoursesqlite3;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, SchoolEntities, dOpf, dsqldbbroker, sqlite3conn, eventlog
  ;

type

  { TopCoursesDB }

  TopCoursesDB = class(TObject, IORMInterface)
  public type
    TopInvitations = specialize TdGSQLdbEntityOpf<TInvitation>;
    TopSessions = specialize TdGSQLdbEntityOpf<TSession>;
    TopSlides = specialize TdGSQLdbEntityOpf<TSlide>;
    TopStudentSpots = specialize TdGSQLdbEntityOpf<TStudentSpot>;
    TopLessons = specialize TdGSQLdbEntityOpf<TLesson>;
    TopCourses = specialize TdGSQLdbEntityOpf<TCourse>;
    TopUsers = specialize TdGSQLdbEntityOpf<TUser>;
  private
    FAutoApply: Boolean;
    FCourses: TopCourses.TEntities;
    FInvitations: TopInvitations.TEntities;
    FLessons: TopLessons.TEntities;
    FLogDebug: Boolean;
    FLogger: TEventLog;
    FopCourses: TopCourses;
    FopInvitations: TopInvitations;
    FopLessons: TopLessons;
    FopSessions: TopSessions;
    FopSlides: TopSlides;
    FopStudentSpots: TopStudentSpots;
    FopUsers: TopUsers;
    FSessions: TopSessions.TEntities;
    FSlides: TopSlides.TEntities;
    FStudentSpots: TopStudentSpots.TEntities;
    FUsers: TopUsers.TEntities;
    function GetCourse: TCourse;
    function GetCourseEntity(EntityType: TEntityType): TCourseElement;
    function GetCourses: TopCourses.TEntities;
    function GetInvitation: TInvitation;
    function GetInvitations: TopInvitations.TEntities;
    function GetLesson: TLesson;
    function GetLessons: TopLessons.TEntities;
    function GetopCourses: TopCourses;
    function GetopInvitations: TopInvitations;
    function GetopLessons: TopLessons;
    function GetopSessions: TopSessions;
    function GetopSlides: TopSlides;
    function GetopStudentSpots: TopStudentSpots;
    function GetopUsers: TopUsers;
    function GetSchoolEntity(EntityType: TEntityType): TSchoolElement;
    function GetSession: TSession;
    function GetSessions: TopSessions.TEntities;
    function GetSlide: TSlide;
    function GetSlides: TopSlides.TEntities;
    function GetStudentSpot: TStudentSpot;
    function GetStudentSpots: TopStudentSpots.TEntities;
    function GetUser: TUser;
    function GetUsers: TopUsers.TEntities;
    procedure Log(aEventType: TEventType; const aMessage: String);
    function NewSession(aUserID: Int64; aEntityType: TEntityType; aEntityID: Integer;
      aTeacher: Int64): Integer;
  protected
    property opCourses: TopCourses read GetopCourses;
    property opInvitations: TopInvitations read GetopInvitations;
    property opLessons: TopLessons read GetopLessons;
    property opUsers: TopUsers read GetopUsers;
    property opSlides: TopSlides read GetopSlides;
    property opSessions: TopSessions read GetopSessions;
    property opStudentSpots: TopStudentSpots read GetopStudentSpots;
  public
    procedure Apply;
    constructor Create;
    function Con: TdSQLdbConnector;
    destructor Destroy; override;
    procedure DeleteCourseEntity(aEntityType: TEntityType);
    procedure ExitDialog(aUserID: Int64);
    function FindEntitiesByParentID(aEntityType: TEntityType; aParentID: Int64;
      IsCourseOwner: Boolean): Integer;
    function FindLessonByID(aLessonID: Integer): Boolean;
    function GetCourse(aCourse: TCourse): Boolean;
    function GetCourseByID(aCourseID: Integer): TCourse;
    function GetCoursesList(aUserID: Int64 = 0): TopCourses.TEntities;
    function GetEntityByID(aEntityType: TEntityType; aID: Int64): TSchoolElement;
//    function GetSlideOrdIndex(aSlideID: Integer): Integer;
    function GetInvitationByID(aInvitationID: Integer): TInvitation;
    function GetInvitationsList(aCourseID: Integer): TopInvitations.TEntities;
    function GetLesson(aLesson: TLesson): Boolean;
    function GetLessonByID(aID: Integer): TLesson;
    function GetLessonIndexByID(aID: Integer): Integer;
    function GetLessonsList(aCourseID: Integer): TopLessons.TEntities;
    function GetSessionByID(aID: Integer): TSession;
    function GetSlideByID(aID: Int64): TSlide;
    function GetSlideIndexByID(aID: Int64): Integer;
    function GetSlidesList(aLessonID: Integer): TopSlides.TEntities;
    function GetSpotByID(aSpotID: Integer): TStudentSpot;
    function GetSpotByUserNCourse(aUserID: Int64; aCourseID: Integer): TStudentSpot;
    function GetSpotListByCourse(aCourseID: Integer; aUserStatus: TUserStatus): TopStudentSpots.TEntities;
    function GetSpotListByUser(aStudentID: Int64; aUserStatus: TUserStatus): TopStudentSpots.TEntities;
    function GetSpotList(aID: Int64; IsCourseOwner: Boolean; aUserStatus: TUserStatus): TopStudentSpots.TEntities; 
    function GetUser(aUser: TUser): Boolean;
    function GetUsersList(): TopUsers.TEntities;
    function GetUserByID(aUserID: Int64): TUser;
    function NewCourse(aCourse: TCourse = nil): Integer;
    function NewInvitation(aCourseID: Integer; aCapacity: Integer=0; aUserStatus: TUserStatus = usStudent): Integer;
    function NewLesson(aLesson: TLesson = nil): Integer;
    function NewSlide(aSlide: TSlide = nil): Integer;
    function NewSchoolEntity(aEntityType: TEntityType; aSchoolEntity: TSchoolElement = nil): Integer;
    procedure NewSessionStudent(aUserID: Int64; aEntityType: TEntityType; aEntityID: Integer;
      aTearcher: Int64);
    function NewStudentSpot(aUserID: Int64; aCourseID: Integer; aUserStatus: TUserStatus = usStudent; aTearcher: Int64 = 0): Integer;
    function opLastInsertID: Integer;
    function SpotNextSlide(aSpot: TStudentSpot; out IsLastLesson: Boolean): Integer;
    function ReplaceEntity(aEntityType: TEntityType; aID1, aID2: Int64): Boolean;
    procedure SaveInvitation;
    procedure SaveUser;
    procedure SaveCourseEntity(aEntityType: TEntityType);
    function SessionOpened(aUserID: Int64; aSession: Integer): Boolean;
    function SessionExists(aUser: Int64): Boolean;
    function SpotInCourse(aUserID: Int64; aCourseID: Integer): Boolean;
    procedure StudentsToSCVDocument(aCSVStream: TStream);
    property Course: TCourse read GetCourse;
    property CourseEntity[EntityType: TEntityType]: TCourseElement read GetCourseEntity;
    property Courses: TopCourses.TEntities read GetCourses;
    property Invitation: TInvitation read GetInvitation;
    property Invitations: TopInvitations.TEntities read GetInvitations;
    property Lesson: TLesson read GetLesson;
    property Lessons: TopLessons.TEntities read GetLessons;
    property LogDebug: Boolean read FLogDebug write FLogDebug;
    property Logger: TEventLog read FLogger write FLogger;
    property User: TUser read GetUser;
    property Users: TopUsers.TEntities read GetUsers;
    property Session: TSession read GetSession;
    property Sessions: TopSessions.TEntities read GetSessions;
    property Slide: TSlide read GetSlide;
    property Slides: TopSlides.TEntities read GetSlides;
    property StudentSpot: TStudentSpot read GetStudentSpot;
    property StudentSpots: TopStudentSpots.TEntities read GetStudentSpots;
    property SchoolEntity[EntityType: TEntityType]: TSchoolElement read GetSchoolEntity;
    property AutoApply: Boolean read FAutoApply write FAutoApply;
  end;

implementation

uses
  csvdocument
  ;

var
  _con: TdSQLdbConnector = nil;
  _query: TdSQLdbQuery = nil;

{ TopCoursesDB }

procedure TopCoursesDB.Apply;
begin
  if Assigned(FopCourses) then
    FopCourses.Apply;
  if Assigned(FopUsers) then
    FopUsers.Apply;
end;

function TopCoursesDB.GetopCourses: TopCourses;
begin
  if not Assigned(FopCourses) then
  begin
    FopCourses:=TopCourses.Create(Con, 'courses');
    FopCourses.Table.PrimaryKeys.Text:='id';
  end;
  Result:=FopCourses;
end;

function TopCoursesDB.GetopInvitations: TopInvitations;
begin
  if not Assigned(FopInvitations) then
  begin
    FopInvitations:=TopInvitations.Create(Con, 'invitations');
    FopInvitations.Table.PrimaryKeys.Text:='id';
  end;
  Result:=FopInvitations;
end;

function TopCoursesDB.GetCourses: TopCourses.TEntities;
begin
  if not Assigned(FCourses) then
    FCourses:=TopCourses.TEntities.Create;
  Result:=FCourses;
end;

function TopCoursesDB.GetInvitation: TInvitation;
begin
  Result:=opInvitations.Entity;
end;

function TopCoursesDB.GetInvitations: TopInvitations.TEntities;
begin
  if not Assigned(FInvitations) then
    FInvitations:=TopInvitations.TEntities.Create;
  Result:=FInvitations;
end;

function TopCoursesDB.GetLesson: TLesson;
begin
  Result:=opLessons.Entity;
end;

function TopCoursesDB.GetLessons: TopLessons.TEntities;
begin
  if not Assigned(FLessons) then
    FLessons:=TopLessons.TEntities.Create;
  Result:=FLessons;
end;

function TopCoursesDB.GetUser(aUser: TUser): Boolean;
begin
  Result:=opUsers.Get(aUser);
  if not Result then
    aUser.Initiate;
end;

function TopCoursesDB.GetCourse: TCourse;
begin
  Result:=opCourses.Entity;
end;

function TopCoursesDB.GetCourseEntity(EntityType: TEntityType): TCourseElement;
begin
  case EntityType of
    seCourse:     Result:=Course;
    seLesson:     Result:=Lesson;
    seSlide:      Result:=Slide;
  else
    Result:=nil;
  end;
end;

function TopCoursesDB.GetopLessons: TopLessons;
begin
  if not Assigned(FopLessons) then
  begin
    FopLessons:=TopLessons.Create(Con, 'lessons');
    FopLessons.Table.PrimaryKeys.Text:='id';
  end;
  Result:=FopLessons;
end;

function TopCoursesDB.GetopSessions: TopSessions;
begin
  if not Assigned(FopSessions) then
  begin
    FopSessions:=TopSessions.Create(Con, 'sessions');
    FopSessions.Table.PrimaryKeys.Text:='id';
  end;
  Result:=FopSessions;
end;

function TopCoursesDB.GetopSlides: TopSlides;
begin
  if not Assigned(FopSlides) then
  begin
    FopSlides:=TopSlides.Create(Con, 'slides');
    FopSlides.Table.PrimaryKeys.Text:='id';
  end;
  Result:=FopSlides;
end;

function TopCoursesDB.GetopStudentSpots: TopStudentSpots;
begin
  if not Assigned(FopStudentSpots) then
  begin
    FopStudentSpots:=TopStudentSpots.Create(Con, 'studentspots');
    FopStudentSpots.Table.PrimaryKeys.Text:='id';
    TStudentSpot(FopStudentSpots.Entity).ORM:=Self;
  end;
  Result:=FopStudentSpots;
end;

function TopCoursesDB.GetopUsers: TopUsers;
begin
  if not Assigned(FopUsers) then
  begin
    FopUsers:=TopUsers.Create(Con, 'users');
    FopUsers.Table.PrimaryKeys.Text:='id';
  end;
  Result:=FopUsers;
end;

function TopCoursesDB.GetSchoolEntity(EntityType: TEntityType
  ): TSchoolElement;
begin
  case EntityType of
    seUser:       Result:=User;
    seCourse:     Result:=Course;
    seLesson:     Result:=Lesson;
    seSlide:      Result:=Slide;
    seInvitation: Result:=Invitation;
    seSession:    Result:=Session;
  else
    Result:=nil;
  end;
end;

function TopCoursesDB.GetSession: TSession;
begin
  Result:=opSessions.Entity;
end;

function TopCoursesDB.GetSessions: TopSessions.TEntities;
begin
  if not Assigned(FSessions) then
    FSessions:=TopSessions.TEntities.Create;
  Result:=FSessions;
end;

function TopCoursesDB.GetSlide: TSlide;
begin
  Result:=opSlides.Entity;
end;

function TopCoursesDB.GetSlides: TopSlides.TEntities;
begin
  if not Assigned(FSlides) then
    FSlides:=TopSlides.TEntities.Create;
  Result:=FSlides;
end;

function TopCoursesDB.GetStudentSpot: TStudentSpot;
begin
  Result:=opStudentSpots.Entity;
end;

function TopCoursesDB.GetStudentSpots: TopStudentSpots.TEntities;
begin
  if not Assigned(FStudentSpots) then
    FStudentSpots:=TopStudentSpots.TEntities.Create;
  Result:=FStudentSpots;
end;

function TopCoursesDB.GetUser: TUser;
begin
  Result:=opUsers.Entity;
end;

function TopCoursesDB.GetUsers: TopUsers.TEntities;
begin
  if not Assigned(FUsers) then
    FUsers:=TopUsers.TEntities.Create;
  Result:=FUsers;
end;

procedure TopCoursesDB.Log(aEventType: TEventType; const aMessage: String);
begin
  if Assigned(FLogger) then
    if FLogDebug and (aEventType=etDebug) then
      FLogger.Debug(aMessage)
    else
      FLogger.Log(aEventType, aMessage);
end;

constructor TopCoursesDB.Create;
begin
  FAutoApply:=True;
  FLogDebug:=False;
end;

function TopCoursesDB.Con: TdSQLdbConnector;
begin
  if not Assigned(_con) then
  begin
    _con := TdSQLdbConnector.Create(nil);
    _con.Database := './'+'courses.sqlite3';
    _con.Driver := 'sqlite3';
    _con.Logger.Active := FLogDebug;
    _con.Logger.FileName := 'db_sqlite3.log';
  end;
  Result := _con;
end;

destructor TopCoursesDB.Destroy;
begin
  FUsers.Free;
  FopUsers.Free;
  FCourses.Free;
  FopCourses.Free;
  FInvitations.Free;
  FopInvitations.Free;
  FLessons.Free;
  FopLessons.Free;
  FSessions.Free;
  FopSessions.Free;
  FSlides.Free;
  FopSlides.Free;
  FStudentSpots.Free;
  FopStudentSpots.Free;
  inherited Destroy;
end;

procedure TopCoursesDB.DeleteCourseEntity(aEntityType: TEntityType);
begin
  case aEntityType of
    seUser:        opUsers.Remove;
    seCourse:      opCourses.Remove;
    seLesson:      opLessons.Remove;
    seSlide:       opSlides.Remove;
    seInvitation:  opInvitations.Remove;
    seSession:     opSessions.Remove;
    seStudentSpot..seTeacher: opStudentSpots.Remove;
  else
    Logger.Error('Unknown entity type while DeleteCourseEntity');
  end;
  if FAutoApply then
    case aEntityType of
      seUser:        opUsers.Apply;
      seCourse:      opCourses.Apply;
      seLesson:      opLessons.Apply;
      seSlide:       opSlides.Apply;
      seInvitation:  opInvitations.Apply;
      seSession:     opSessions.Apply;
      seStudentSpot..seTeacher: opStudentSpots.Apply;
    else
      Logger.Error('Unknown entity type while DeleteCourseEntity');
    end;
end;

procedure TopCoursesDB.ExitDialog(aUserID: Int64);
begin
  GetUserByID(aUserID).Session:=0;
  SaveUser;
end;

function TopCoursesDB.FindEntitiesByParentID(aEntityType: TEntityType;
  aParentID: Int64; IsCourseOwner: Boolean): Integer;
begin
  case aEntityType of
    seUser:        Result:=GetUsersList().Count;
    seCourse:      Result:=GetCoursesList(aParentID).Count;
    seLesson:      Result:=GetLessonsList(aParentID).Count;
    seSlide:       Result:=GetSlidesList(aParentID).Count;
    seInvitation:  Result:=GetInvitationsList(aParentID).Count;
    seStudentSpot: Result:=GetSpotList(aParentID, IsCourseOwner, usStudent).Count;
    seStudent:     Result:=GetSpotList(aParentID, IsCourseOwner, usStudent).Count;
    seTeacher:    Result:=GetSpotList(aParentID, IsCourseOwner, usTeacher).Count;
    seSession:     Result:=0; // No parent entity
  else
    Result:=0;
    Log(etError, 'FindEntitiesByParentID : unexpected entity type ('+EntityTypeToString(aEntityType)+')!');
  end;
end;

function TopCoursesDB.FindLessonByID(aLessonID: Integer): Boolean;
begin
  Lesson.id:=aLessonID;
  Result:=opLessons.Get;
  if not Result then
    Lesson.Initiate;
end;

function TopCoursesDB.GetCourse(aCourse: TCourse): Boolean;
begin
  Result:=opCourses.Get(aCourse);
  if not Result then
    aCourse.Initiate;
end;

function TopCoursesDB.NewCourse(aCourse: TCourse): Integer;
begin
  if not Assigned(aCourse) then
    aCourse:=Course;
  opCourses.Add(aCourse);
  aCourse.id:=opLastInsertID;
  Result:=aCourse.id;
  if FAutoApply then
    FopCourses.Apply;
end;

function TopCoursesDB.NewInvitation(aCourseID: Integer; aCapacity: Integer;
  aUserStatus: TUserStatus): Integer;
begin
  Invitation.Capacity:=aCapacity;
  Invitation.Course:=aCourseID;
  Invitation.UserStatus:=aUserStatus;
  opInvitations.Add(Invitation);
  Invitation.id:=opLastInsertID;
  Result:=Invitation.id;
  if FAutoApply then
    opInvitations.Apply;
end;

function TopCoursesDB.NewLesson(aLesson: TLesson): Integer;
begin
  if not Assigned(aLesson) then
    aLesson:=Lesson;
  opLessons.Add(aLesson);
  aLesson.id:=opLastInsertID;
  Result:=aLesson.id;
  if FAutoApply then
    FopLessons.Apply;
end;

function TopCoursesDB.NewSlide(aSlide: TSlide): Integer;
begin
  if not Assigned(aSlide) then
    aSlide:=Slide;
  opSlides.Add(aSlide);
  aSlide.id:=opLastInsertID;
  Result:=aSlide.id;
  if FAutoApply then
    FopSlides.Apply;
end;

function TopCoursesDB.NewSchoolEntity(aEntityType: TEntityType;
  aSchoolEntity: TSchoolElement): Integer;
begin
  case aEntityType of
    seCourse: Result:=NewCourse(aSchoolEntity as TCourse);
    seLesson: Result:=NewLesson(aSchoolEntity as TLesson);
    seSlide:  Result:=NewSlide(aSchoolEntity as TSlide);
  else
    Log(etError, 'Unknown school entity type! Procedure NewSchoolEntity...');
    Result:=0;
  end;
end;

procedure TopCoursesDB.NewSessionStudent(aUserID: Int64;
  aEntityType: TEntityType; aEntityID: Integer; aTearcher: Int64);
begin
  GetUserByID(aUserID).Session:=NewSession(aUserID, aEntityType, aEntityID, aTearcher);
  SaveUser;
end;

function TopCoursesDB.NewSession(aUserID: Int64; aEntityType: TEntityType;
  aEntityID: Integer; aTeacher: Int64): Integer;
begin
  Session.Student:=aUserID;
  Session.SourceEntity:=EntityTypeToString(aEntityType);
  Session.EntityID:=aEntityID;
  Session.Teacher:=aTeacher;
  opSessions.Add(Session);
  Session.id:=opLastInsertID;
  Result:=Session.ID;
  if FAutoApply then
    opSessions.Apply;
end;

function TopCoursesDB.NewStudentSpot(aUserID: Int64; aCourseID: Integer;
  aUserStatus: TUserStatus; aTearcher: Int64): Integer;
begin
  StudentSpot.User:=aUserID;
  StudentSpot.Course:=aCourseID;
  StudentSpot.UserStatus:=aUserStatus;
  StudentSpot.Teacher:=aTearcher;
  opStudentSpots.Add(StudentSpot);
  StudentSpot.id:=opLastInsertID;
  Result:=StudentSpot.ID;
  if FAutoApply then
    opStudentSpots.Apply;
end;

function TopCoursesDB.opLastInsertID: Integer;
begin
  if not Assigned(_query) then
    _query:=TdSQLdbQuery.Create(Con);
  _query.SQL.Text:='SELECT last_insert_rowid();';
  _query.Open;
  Result:=_query.Fields.Fields[0].AsInteger;
  _query.Close;
end;

function TopCoursesDB.SpotNextSlide(aSpot: TStudentSpot; out IsLastLesson: Boolean): Integer;
var
  i: Integer;
begin
  Result:=aSpot.Lesson;
  GetLessonsList(aSpot.Course);
  i:=GetLessonIndexByID(Result);
  if i<Lessons.Count-1 then
  begin
    IsLastLesson:=False;
    Result:=Lessons.Items[i+1].id;
  end
  else begin
    IsLastLesson:=True;
    Inc(Result);
  end;
  aSpot.Lesson:=Result;
end;

function TopCoursesDB.ReplaceEntity(aEntityType: TEntityType; aID1, aID2: Int64
  ): Boolean;
var
  aEntity: TSchoolElement;
begin
  aEntity:=SchoolClasses[aEntityType].Create;
  try
    aEntity.Assign(GetEntityByID(aEntityType, aID1));
    GetEntityByID(aEntityType, aID2);
    SchoolEntity[aEntityType].ID64:=aID1;
    SaveCourseEntity(aEntityType);
    SchoolEntity[aEntityType].Assign(aEntity);
    SchoolEntity[aEntityType].ID64:=aID2;
    SaveCourseEntity(aEntityType);
  finally
    aEntity.Free;
  end;
end;

procedure TopCoursesDB.SaveInvitation;
begin
  opInvitations.Modify(Invitation);
  if FAutoApply then
    opInvitations.Apply;
end;

function TopCoursesDB.GetCourseByID(aCourseID: Integer): TCourse;
begin
  if Course.id<>aCourseID then
  begin
    Course.id:=aCourseID;
    if not opCourses.Get then
      Course.Initiate;
  end;
  Result:=Course;
end;

function TopCoursesDB.GetCoursesList(aUserID: Int64): TopCourses.TEntities;
var
  aCourse: TCourse;
begin
  if aUserID=0 then
    aUserID:=User.id;
  aCourse:=TCourse.Create;
  try
    aCourse.Owner:=aUserID;
    Courses.Clear;
    opCourses.Find(aCourse, Courses, 'owner=:owner');
  finally
    aCourse.Free;
  end;
  Result:=FCourses;
end;

function TopCoursesDB.GetEntityByID(aEntityType: TEntityType; aID: Int64
  ): TSchoolElement;
begin
  case aEntityType of
    seUser:       Result:=GetUserByID(aID);
    seCourse:     Result:=GetCourseByID(aID);
    seLesson:     Result:=GetLessonByID(aID);
    seSlide:      Result:=GetSlideByID(aID);
    seInvitation: Result:=GetInvitationByID(aID);
    seStudentSpot..seTeacher: Result:=GetSpotByID(aID);
    seSession:    Result:=GetSessionByID(aID);
  else
    Result:=nil;
  end;
end;

function TopCoursesDB.GetInvitationByID(aInvitationID: Integer): TInvitation;
begin
  if Invitation.ID<>aInvitationID then
  begin
    Invitation.id:=aInvitationID;
    if not opInvitations.Get(Invitation) then
      Invitation.Initiate;
  end;
  Result:=Invitation;
end;

function TopCoursesDB.GetInvitationsList(aCourseID: Integer): TopInvitations.TEntities;
var
  aInvitation: TInvitation;
begin
  aInvitation:=TInvitation.Create;
  try
    aInvitation.Course:=aCourseID;
    Invitations.Clear;
    opInvitations.Find(aInvitation, FInvitations, 'course=:course AND applied<capacity');
  finally
    aInvitation.Free;
  end;
  Result:=Invitations;
end;

function TopCoursesDB.GetLesson(aLesson: TLesson): Boolean;
begin
  Result:=opLessons.Get(aLesson);
  if not Result then
    aLesson.Initiate;
end;

function TopCoursesDB.GetSpotList(aID: Int64; IsCourseOwner: Boolean;
  aUserStatus: TUserStatus): TopStudentSpots.TEntities;
begin
  if IsCourseOwner then
    Result:=GetSpotListByCourse(aID, aUserStatus)
  else
    Result:=GetSpotListByUser(aID, aUserStatus);
end;

function TopCoursesDB.GetSpotListByUser(aStudentID: Int64;
  aUserStatus: TUserStatus): TopStudentSpots.TEntities;
var
  aStudentSpot: TStudentSpot;
begin
  aStudentSpot:=TStudentSpot.Create;
  try
    aStudentSpot.User:=aStudentID;
    aStudentSpot.UserStatus:=aUserStatus;
    StudentSpots.Clear;
    opStudentSpots.Find(aStudentSpot, FStudentSpots, 'user=:user AND status=:status');
  finally
    aStudentSpot.Free;
  end;
  Result:=StudentSpots;
end;

function TopCoursesDB.GetLessonByID(aID: Integer): TLesson;
begin
  if Lesson.id<>aID then
  begin
    Lesson.id:=aID;
    if not opLessons.Get then
      Lesson.Initiate;
  end;
  Result:=Lesson;
end;

function TopCoursesDB.GetLessonIndexByID(aID: Integer): Integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=Lessons.Count-1 downto 0 do
    if FLessons.Items[i].id=aID then
      Exit(i);
end;

function TopCoursesDB.GetLessonsList(aCourseID: Integer): TopLessons.TEntities;
var
  aLesson: TLesson;
begin
  aLesson:=TLesson.Create;
  try
    aLesson.Course:=aCourseID;
    Lessons.Clear;
    opLessons.Find(aLesson, FLessons, 'course=:course');
  finally
    aLesson.Free;
  end;
  Result:=Lessons;
end;

function TopCoursesDB.GetSessionByID(aID: Integer): TSession;
begin
  if Session.ID<>aID then
  begin
    Session.id:=aID;
    if not opSessions.Get then
      Session.Initiate;
  end;
  Result:=Session;
end;

function TopCoursesDB.GetSlideByID(aID: Int64): TSlide;
begin
  if Slide.id<>aID then
  begin
    Slide.id:=aID;
    if not opSlides.Get(Slide) then
      Slide.Initiate;
  end;
  Result:=Slide;
end;

function TopCoursesDB.GetSlideIndexByID(aID: Int64): Integer;
var
  i: Integer;
begin
  Result:=-1;
  for i:=Slides.Count-1 downto 0 do
    if FSlides.Items[i].id=aID then
      Exit(i);
end;

function TopCoursesDB.GetSlidesList(aLessonID: Integer): TopSlides.TEntities;
var
  aSlide: TSlide;
begin
  aSlide:=TSlide.Create;
  try
    aSlide.Lesson:=aLessonID;
    Slides.Clear;
    opSlides.Find(aSlide, FSlides, 'lesson=:lesson');
  finally
    aSlide.Free;
  end;
  Result:=Slides;
end;

function TopCoursesDB.GetSpotByID(aSpotID: Integer): TStudentSpot;
begin
  if StudentSpot.id<>aSpotID then
  begin
    StudentSpot.id:=aSpotID;
    if not opStudentSpots.Get(StudentSpot) then
      StudentSpot.Initiate;
  end;
  Result:=StudentSpot;
end;

function TopCoursesDB.GetSpotByUserNCourse(aUserID: Int64; aCourseID: Integer
  ): TStudentSpot;
begin
  if (StudentSpot.User<>aUserID) or (StudentSpot.Course<>aCourseID) then
  begin
    StudentSpot.User:=aUserID;
    StudentSpot.Course:=aCourseID;
    if not opStudentSpots.Find(StudentSpot, 'user=:user AND course=:course') then
      StudentSpot.Initiate;
  end;
  Result:=StudentSpot;
end;

function TopCoursesDB.GetSpotListByCourse(aCourseID: Integer; aUserStatus: TUserStatus
  ): TopStudentSpots.TEntities;
var
  aStudentSpot: TStudentSpot;
begin
  aStudentSpot:=TStudentSpot.Create;
  try
    aStudentSpot.Course:=aCourseID;
    aStudentSpot.UserStatus:=aUserStatus;
    StudentSpots.Clear;
    opStudentSpots.Find(aStudentSpot, FStudentSpots, 'course=:course AND status=:status');
  finally
    aStudentSpot.Free;
  end;
  Result:=StudentSpots;
end;

function TopCoursesDB.GetUsersList(): TopUsers.TEntities;
var
  aUser: TUser;
begin
  aUser:=TUser.Create;
  try
    Users.Clear;
    opUsers.List(FUsers);
  finally
    aUser.Free;
  end;
  Result:=Users;
end;

function TopCoursesDB.GetUserByID(aUserID: Int64): TUser;
begin
  if User.id<>AUserID then
  begin
    User.id:=AUserID;
    if not opUsers.Get then
      User.Initiate;
  end;
  Result:=User;
end;

procedure TopCoursesDB.SaveUser;
var
  aUser: TUser;
begin
  aUser:=TUser.Create;
  try
    aUser.id:=User.id;
    if opUsers.Get(aUser) then
      FopUsers.Modify(User)
    else
      FopUsers.Add(User, False);
  finally
    aUser.Free;
  end;
  if FAutoApply then
    opUsers.Apply;
end;

procedure TopCoursesDB.SaveCourseEntity(aEntityType: TEntityType);
begin
  case aEntityType of
    seUser:                    opUsers.Modify(User, False);
    seCourse:                  opCourses.Modify(Course);
    seLesson:                  opLessons.Modify(Lesson);
    seSlide:                   opSlides.Modify(Slide);
    seInvitation:              opInvitations.Modify(Invitation);
    seStudentSpot..seTeacher: opStudentSpots.Modify(StudentSpot);
  else
    Logger.Error('Unknown entity type while SaveCourseEntity');
  end;
  if FAutoApply then
    case aEntityType of
      seUser:                    opUsers.Apply;
      seCourse:                  opCourses.Apply;
      seLesson:                  opLessons.Apply;
      seSlide:                   opSlides.Apply;
      seInvitation:              opInvitations.Apply;
      seStudentSpot..seTeacher:  opStudentSpots.Apply;
    else
      Logger.Error('Unknown entity type while SaveCourseEntity');
    end;
end;

function TopCoursesDB.SessionOpened(aUserID: Int64; aSession: Integer): Boolean;
var
  aUser: TUser;
begin
  aUser:=TUser.Create;
  aUser.id:=aUserID;
  try
    if opUsers.Get(aUser) then
      Result:=aUser.Session=aSession
    else
      Result:=False;
  finally
    aUser.Free;
  end;
end;

function TopCoursesDB.SessionExists(aUser: Int64): Boolean;
var
  aSessionID: Integer;
begin
  aSessionID:=GetUserByID(aUser).Session;
  Result:=aSessionID<>0;
  if Result then
    GetSessionByID(aSessionID);
end;

function TopCoursesDB.SpotInCourse(aUserID: Int64; aCourseID: Integer): Boolean;
begin
  StudentSpot.User:=aUserID;
  StudentSpot.Course:=aCourseID;
  Result:=opStudentSpots.Find(StudentSpot, 'user=:user AND course=:course');
end;

procedure TopCoursesDB.StudentsToSCVDocument(aCSVStream: TStream);
var
  aCSV: TCSVDocument;
  iSpot: TStudentSpot;
begin
  aCSV:=TCSVDocument.Create;
  aCSV.Delimiter:=';';
  try
    for iSpot in StudentSpots do
    begin
      iSpot.ORM:=Self;
      aCSV.AddRow(iSpot.User.ToString);
      aCSV.Cells[1, aCSV.RowCount-1]:=iSpot._User.Name;
      aCSV.Cells[2, aCSV.RowCount-1]:=iSpot.Lesson.ToString;  
      aCSV.Cells[3, aCSV.RowCount-1]:=iSpot._Lesson.Name;
    end;
    aCSV.SaveToStream(aCSVStream);
  finally
    aCSV.Free;
  end;
end;

finalization
  FreeAndNil(_con);

end.

