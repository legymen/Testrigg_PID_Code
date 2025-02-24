import java.util.Map;

class Graph {
    float xpos, ypos;
    String title, id, ylabel, xlabel;
    ArrayList<PVector> points;
    boolean show = true;
    float length = width/5;
    float axisheight = height/8;
    float xscale = 20;
    float yscale = 1;
    float graphtime = 0;
    float graphheight = 0;

    Graph(float _xpos, float _ypos, String _id, String _title, String _ylabel, String _xlabel)
    {
        xpos = _xpos;
        ypos = _ypos;
        points = new ArrayList<PVector>();
        title = _title;
        xlabel = _xlabel;
        ylabel = _ylabel;
        id = _id;
    }

    void plot() {
        
        stroke(255,255,255);
        strokeWeight(1.0);
        // Create axes
        line(xpos, ypos, xpos + length, ypos); // x-axis
        line(xpos, ypos - axisheight, xpos, ypos + axisheight); // y-axis

        // Create markers
        float mlength = axisheight/40;
        // in dir(x):
        for (float i = xpos + length/20; i < xpos + length; i += length/20)
        {
            line(i, ypos - mlength, i, ypos + mlength);
        }
        // in dir(y):
        for (float i = axisheight / 10; i < axisheight; i += axisheight / 10)
        {
            line(xpos - mlength, ypos +  i, xpos + mlength, ypos + i);
            line(xpos - mlength, ypos - i, xpos + mlength, ypos - i);
        }

        // Render text.
        textSize(15);
        text(xlabel, xpos + length + (length/8), ypos);
        text(ylabel, xpos, ypos -axisheight - (axisheight/10));
        textSize(20);
        text(title, xpos + length/2, ypos - axisheight/0.9);

        // Plot graph between datapoints.
        pushMatrix();
        translate(xpos, ypos); // Make origin of graph temporary origin of sketch.
        scale(1, -1); // Make positive y go upwards to fit incoming data.

        graphtime = length;
        graphheight = axisheight;
        if (points.size() > 1)
        {
            for (int i = 0; i < points.size() - 1; i++)
            {
                stroke(255, 10, 0);
                strokeWeight(2.0);
                PVector p1 = points.get(i);
                PVector p2 = points.get(i + 1);
                graphtime = p2.x * xscale > graphtime ? p2.x * xscale : graphtime;
                graphheight = p2.y * yscale > graphheight ? p2.y * yscale : graphheight;
                xscale = map(xscale, 0.0, graphtime, 0.0, length);
                yscale = map(yscale, 0.0, graphheight, 0.0, axisheight);
                line(xscale*p1.x, yscale*p1.y, xscale*p2.x, yscale*p2.y); 
            }
        }
        popMatrix();

    }

    void updatevalues()
    {
        try
        {
            PVector point = new PVector(data.get("t"), data.get(id));
            points.add(point);
        }
        catch (Exception e)
        {
            ;
        }
            
    }

    void changestate()
    {
        show = !show;
    }
}