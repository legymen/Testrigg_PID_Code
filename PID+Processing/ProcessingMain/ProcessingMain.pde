import processing.serial.*;
import java.util.Map;

// Arduino variables.
Serial myPort;
String indata; // Value from Serial port.
String estr;
String timestr;
String sstr;
HashMap<String, Float> data;

// Chose to have these as variables because then classes can have different checks for them, instead of the built in functions having to go through every object just to tell them a key or a mouse button has been pressed.
boolean mouseClicked = false;
boolean keyClicked = false;

float kP = 0, kI = 0, kD = 0;
float constfieldx, constfieldy;

ArrayList<Graph> graphs;
ArrayList<Button> buttons;
ArrayList<InputField> inputfields;
ArrayList<Slider> sliders;
PFont textfont;

float lastW;
float lastH;
float scaleX = 1;
float scaleY = 1;

/* TODO:
    In arduinoinit(): Clear values from Serial in a better way, to be able to start graphs from t = 0.
    Look for bugs with window resizing.
    Add PID-Regulator code in the Arduino file.
    Add "snapshot" function.
*/

public void settings() 
{
    //fullScreen(P2D); // Should OpenGL be used as renderer?
    size(1800,1000, P2D);
    smooth(4);
}

void setup()
{   
    surface.setResizable(true);
    surface.setTitle("PID-Regulator");
    background(#12153c);
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    stroke(255, 255, 255);
    textfont = createFont("CascadiaCode.ttf", 18);
    textFont(textfont);
    
    while (arduinoinit(115200) != 0) {delay(2000);}; // MPU-6050 *might* work better with 115200 as baudrate as compared to 921600.

    data = new HashMap<String, Float>();
    graphs = new ArrayList<Graph>();
    graphs.add(new Graph(width/8, height/4, "e", "Error", "e [deg]", "time [s]"));
    graphs.add(new Graph(width/2, height/4, "s", "Sum", "s [deg]", "time [s]"));
    graphs.add(new Graph(width/8, height/1.5, "pow", "Power", "", "time [s]"));

    buttons = new ArrayList<Button>();
    sliders = new ArrayList<Slider>();

    inputfields = new ArrayList<InputField>();
    inputfields.add(new InputField(width/1.5, height/1.5 - height/18, width/18, height/(1000/30), "p", true));
    inputfields.add(new InputField(width/1.5, height/1.5, width/18, height/(1000/30), "i", true));
    inputfields.add(new InputField(width/1.5, height/1.5 + height/18, width/18, height/(1000/30), "d", true));

    lastW = width;
    lastH = height;
}

void draw()
{
    if (lastW != width || lastH != height)
    {
        scaleX = width/lastW;
        scaleY = height/lastH;
    }
    scale(scaleX, scaleY);

    background(#12153c);
    fill(255,255,255);
    getserialinput();

    // Plot all shown graphs.
    for (int i = 0; i < graphs.size(); i++)
    {
        Graph current = graphs.get(i);
        current.updatevalues();
        if (current.show)
        {
            current.plot();
        }
    }

    // Update buttons.
    for (int i = 0; i < buttons.size(); i++)
    {
        Button current = buttons.get(i);
        current.update();
    }

    // Update inputfields.
    for (int i = 0; i < inputfields.size(); i++)
    {
        InputField current = inputfields.get(i);
        current.update();
    }

     // Update sliders.
    for (int i = 0; i < sliders.size(); i++)
    {
        Slider current = sliders.get(i);
        current.update();
    }

    plotinfo();

    mouseClicked = false;
    keyClicked = false;
}

int arduinoinit(int baudRate) {
    try 
    {
        myPort = new Serial(this, Serial.list()[0], baudRate);
    }
    catch (Exception RuntimeException)
    {
        println("Port not found. Is the Arduino connected to the correct port?");
        return 1;
    }

    println("Arduino found. Baud Rate: " + baudRate, "Please wait.");
    delay(2000);
    myPort.clear();
    return 0;
}

void getserialinput()
{
    // If data is available.
    if (myPort.available() > 0) 
    {  
        indata = myPort.readStringUntil('\n');
        timestr = readbetween(indata,'t','e');
        estr = readbetween(indata, 'e', 's');
        sstr = readbetween(indata, 's', '\n');
        try 
        {
            data.put("e", Float.valueOf(estr.trim()));
            data.put("t", Float.valueOf(timestr.trim()));
            data.put("s", Float.valueOf(sstr.trim()));
        }
        catch (Exception e)
        {
            ;
        }
    }
}

String readbetween(String s, char f, char t)
{
    if (s != "" && s != null)
    {
        int fi = s.indexOf(f);
        int ti = s.indexOf(t);
        if (fi >= 0 && ti > 0)
        {
            return s.substring(fi + 1, ti);
        }
        else 
        {
            return "";
        }
    }
    else
    {
        return "";
    }
}

void mousePressed()
{
    mouseClicked = true;
} 

void keyPressed()
{
    keyClicked = true;
}

// Draws general info about the Regulator to the screen.
void plotinfo()
{
    textSize(20);
    textAlign(CENTER, CENTER);
    fill(255,255,255);
    text("P = " + kP, width/(scaleX*1.5) - width/(scaleX*16), height/(scaleY*1.5) - height/(scaleY * 18));
    text("I = " + kI, width/(scaleX*1.5) - width/(scaleX*16), height/(scaleY*1.5));
    text("D = " + kD, width/(scaleX*1.5) - width/(scaleX*16), height/(scaleY*1.5) + height/(scaleY * 18));

    text("FOR DEBUGGING, FPS: " + round(frameRate), width/10, height/30);
}

void changepidconst(String id, float val)
{
    switch (id)
    {
            case "p":
                kP = val;
                break;
            case "i":
                kI = val;
                break;
            case "d":
                kD = val;
                break;
            default:
                break;
    }
    myPort.write(id+"\n"+val+"\n");
}
