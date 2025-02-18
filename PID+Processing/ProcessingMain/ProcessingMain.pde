import processing.serial.*;
import java.util.Map;

// Arduino variables.
Serial myPort;
String indata; // Value from Serial port.
String estr;
String timestr;
HashMap<String, Float> data;

ArrayList<Graph> graphs;
PFont textfont;

public void settings() 
{
    //fullScreen(); // Should OpenGL be used as renderer?
    size(1800,1000);
}

void setup()
{
    background(60, 60, 60);
    textAlign(CENTER, CENTER);
    stroke(255, 255, 255);
    textfont = createFont("CascadiaCode.ttf", 18);
    textFont(textfont);

    while (arduinoinit(921600) != 0) {delay(2000);};

    data = new HashMap<String, Float>();
    graphs = new ArrayList<Graph>();
    graphs.add(new Graph(width/8, height/4, "e", "Error", "e [deg]", "time [s]"));
    graphs.add(new Graph(width/2, height/4, "s", "Sum", "s [deg]", "time [s]"));
}

void draw()
{
    background(60, 60, 60);
    getserialinput();

    // Plot all shown graphs.
    for (int i = 0; i < graphs.size(); i++)
    {
        Graph current = graphs.get(i);
        current.updatevalues(data);
        if (current.show); current.plot();
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
    // TODO: Send clear-signal to Arduino with correct timing.
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
        estr = readbetween(indata, 'e', '\n');
        try 
        {
            data.put("e", Float.valueOf(estr.trim()));
            data.put("t", Float.valueOf(timestr.trim()));
            data.put("s", 3*data.get("e"));
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