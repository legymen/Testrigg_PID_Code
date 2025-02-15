import processing.serial.*;

// Arduino variables.
Serial myPort;
String indata; // Value from Serial port.
String data;
String timestr;
int time;

ArrayList<Graph> graphs;
PVector epoint;
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

    while (arduinoinit(921600) != 0);
    delay(1000);

    graphs = new ArrayList<Graph>();
    graphs.add(new Graph(width/8, height/4, "Error", "e [deg]", "time [s]"));
}

void draw()
{
    getserialinput();
    background(60, 60, 60);

    // Plot all shown graphs.
    for (int i = 0; i < graphs.size(); i++)
    {
        Graph current = graphs.get(i);
        if (current.show); current.plot();
    }
}

int arduinoinit(int baudRate) {
    String portName = "COM3"; // Change the number (in this case) to match the corresponding port number connected to your Arduino.    
    try 
    {
        myPort = new Serial(this, portName, baudRate);
    }
    catch (Exception RuntimeException)
    {
        println("Port " + portName + " not found. Is the Arduino connected to the correct port?");
        return 1;
    }

    println("Arduino found on port " + portName, ". Baud Rate: " + baudRate);
    return 0;
}

// TODO: Since only numbers are being sent through the Serial from the Arduino, maybe sending bytes would be faster?
void getserialinput()
{
    // If data is available.
    if (myPort.available() > 0) 
    {  
        indata = myPort.readStringUntil('\n');
        data = readbetween(indata,'D','t');
        timestr = readbetween(indata, 't', '\n');
        println(data + " " + timestr);
    }
}

String readuntil(String s, char c)
{
    if (s != "" && s != null)
    {
        int index = s.indexOf(c);
        if (index != -1)
        {
            String newstr = s.substring(0, index);
            return newstr;
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

// Kind of slow, so is readuntil(). Works for now though.
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