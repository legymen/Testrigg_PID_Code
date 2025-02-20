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
float constbuttonx, constbuttony;

ArrayList<Graph> graphs;
ArrayList<Button> buttons;
ArrayList<InputField> inputfields;
PFont textfont;

// Note, inputfields can be connected to buttons by giving them the same id!

/* TODO:
    In arduinoinit(): Clear values from Serial in a better way, to be able to start graphs from t = 0.
    Make user able to submit inputfields by pressing ENTER, not only by a button as it currently is.
*/

public void settings() 
{
    //fullScreen(); // Should OpenGL be used as renderer?
    size(1800,1000);
}

void setup()
{
    background(60, 60, 60);
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

    buttons = new ArrayList<Button>();

    constbuttonx = width/1.05;
    constbuttony = height/4;
    buttons.add(new Button(constbuttonx, constbuttony-(height/20), width/25.7, height/33.3, 5.0, "Change", "p"));
    buttons.add(new Button(constbuttonx, constbuttony, width/25.7, height/33.3, 5.0, "Change", "i"));
    buttons.add(new Button(constbuttonx, constbuttony+(height/20), width/25.7, height/33.3, 5.0, "Change", "d"));

    inputfields = new ArrayList<InputField>();
    inputfields.add(new InputField(constbuttonx - (width/17), constbuttony-(height/20), 100, 40, "p"));
    inputfields.add(new InputField(constbuttonx - (width/17), constbuttony, 100, 40, "i"));
    inputfields.add(new InputField(constbuttonx - (width/17), constbuttony+(height/20), 100, 40, "d"));
}

void draw()
{
    background(60, 60, 60);
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
    fill(255,255,255);
    text("K = " + kP, constbuttonx - width/8, constbuttony - (height/20));
    text("K = " + kI, constbuttonx - width/8, constbuttony);
    text("K = " + kD, constbuttonx - width/8, constbuttony + (height/20));
    textSize(12);
    text("p", constbuttonx - width/7.2, height/4 - (height/20) + height/115);
    text("i", constbuttonx - width/7.2, height/4 + height/115);
    text("d", constbuttonx - width/7.2, height/4 + (height/20) + height/115);
}