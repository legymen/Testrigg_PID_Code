import processing.serial.*;
import java.util.Map;

// Arduino variables.
Serial myPort;
String indata; // Value from Serial port.
String estr;
String timestr;
String sstr;
HashMap<String, Float> data;

ArrayList<Graph> graphs;
PFont textfont;

ArrayList<Button> buttons;

/* TODO:
    In arduinoinit(): Clear values from Serial in a better way, to be able to start graphs from t = 0.
    Make buttons able to execute their own functions (or something like that). Currently all buttons do the same thing.
    Fix Serial::write() slowing things down (Solution may be throwing Strings out the window and sending bytes instead).
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

    while (arduinoinit(921600) != 0) {delay(2000);};

    data = new HashMap<String, Float>();
    graphs = new ArrayList<Graph>();
    graphs.add(new Graph(width/8, height/4, "e", "Error", "e [deg]", "time [s]"));
    graphs.add(new Graph(width/2, height/4, "s", "Sum", "s [deg]", "time [s]"));

    buttons = new ArrayList<Button>();
    buttons.add(new Button(width/8 - width/40, height/4, 70, 30, 2.0, "Add", "a"));
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

    for (int i = 0; i < buttons.size(); i++)
    {
        Button current = buttons.get(i);
        current.update();
    }
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
    for (int i = 0; i < buttons.size(); i++)
    {
        Button current = buttons.get(i);
        if (current.hovered)
        {
            current.clicked();
        }
    }
}

