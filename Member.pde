// ==== M E M B E R ====
class Member 
{
  int id;
  String name;
  float x, y, z;
  int yearOfBirth;
  String gender;
  String origGender;          
  int level;
  int group;
  int texIndex;
  int pngTexIndex = -1;  
  int animFrame = 0;
  float objRotX = 0, objRotY = 0, objRotZ = 0;
  float scaleFactor = 1.0;
  boolean isWireframe = false;
  boolean isShapeOutline = false;
  int genderDisplayMode = 0;  // 0=Bar, 1=Symbol, 2=Both, 3=None
  float sx, sy, sz;
  boolean spinActive = false;
  float origX, origY, origZ;
  ArrayList<PVector> trail = new ArrayList<PVector>();

  // Constructor used when loading from a saved file
  Member() 
  {
    this.texIndex = 0;
    this.scaleFactor = 1.0;
    this.origGender = "";
  }

  // CSV constructor reads columns in order:
  //   ID, Name, X, Y, Z, YearOfBirth, Gender, Level, Group
  // Also stores original position (origX/Y/Z) for "Reset Position" and origGender for gender reset
  Member(TableRow row) 
  {
    this.id          = row.getInt(0);
    this.name        = row.getString(1);
    this.x           = row.getFloat(2);
    this.y           = row.getFloat(3);
    this.z           = row.getFloat(4);
    this.yearOfBirth = row.getInt(5);
    this.gender      = row.getString(6);
    this.origGender  = this.gender;
    this.level       = row.getInt(7);
    this.group       = row.getInt(8);
    this.texIndex    = int(random(3));
    this.scaleFactor = 1.0;
    this.origX = this.x;
    this.origY = this.y;
    this.origZ = this.z;
  }

  // Returns a colour from the yearColors based on yearOfBirth
  color getColor() 
  {
    int idx = constrain(yearOfBirth - 2000, 0, yearColors.length - 1);
    return yearColors[idx];
  }

  // Computes the size depend on Level
  float getSize() 
  {
    return map(level, 1, 6, levelMinSize, levelMaxSize) * scaleFactor;
  }

  // Returns true if it is in the multi selection list
  boolean isSelected() 
  {
    return selectedMembers.contains(this);
  }
}
