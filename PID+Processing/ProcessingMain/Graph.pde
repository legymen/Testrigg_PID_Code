
class Graph {
    float xpos, ypos;
    String id, ylabel, xlabel;
    ArrayList<PVector> points;
    boolean show = true;
    float length = width/5;
    float axisheight = height/8;
    Graph(float _xpos, float _ypos, String _id, String _ylabel, String _xlabel)
    {
        xpos = _xpos;
        ypos = _ypos;
        points = new ArrayList<PVector>();
        id = _id;
        xlabel = _xlabel;
        ylabel = _ylabel;
    }

    void plot() {

        // Create axes
        line(xpos, ypos, xpos + length, ypos); // x-axis
        line(xpos, ypos - axisheight, xpos, ypos + axisheight);

        // Render text.
        text(id, xpos + length/2, ypos - axisheight);
        text(xlabel, xpos + length + (length/10), ypos);
        text(ylabel, xpos, ypos -axisheight - (axisheight/10));

        // Plot graph between datapoints.
        pushMatrix();
        translate(xpos, ypos); // Make origin of graph temporary origin of sketch.
        scale(1, -1); // Make positive y go upwards to fit incoming data.

        if (points.size() > 1)
        {
            for (int i = 0; i < points.size() - 1; i++)
            {
                stroke(0, 10, 255);
                PVector p1 = points.get(i);
                PVector p2 = points.get(i + 1);
                line(p1.x, p1.y, p2.x, p2.y);
            }
        }
        popMatrix();

    }

    void updatevalues(PVector point)
    {
        points.add(point);
    }
}