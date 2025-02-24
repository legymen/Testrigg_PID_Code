
class Slider {
    float xpos, ypos, min, max, val, length = width/10, rectw = width/200, recth = height/50, rectpos;
    String id;
    color c;
    boolean hovered = false;
    boolean dragging = true;

    Slider(float _xpos, float _ypos, float _min, float _max, String _id)
    {
        xpos = _xpos;
        ypos = _ypos;
        min = _min;
        max = _max;
        id = _id;
        val = min;
        rectpos = xpos;
    }

    void update()
    {
        // Create slider.
        stroke(255,255,255);
        line(xpos, ypos, xpos + length, ypos);

        // Check if hovered.
        if ((mouseX > (rectpos - rectw/2) * scaleX && mouseX < (rectpos + rectw/2) * scaleX && mouseY > (ypos - recth/2) * scaleY && mouseY < (ypos + recth/2) * scaleY) || dragging)
        {
            c = color(200, 200, 200);
            hovered = true;
        }
        else 
        {
            c = color(255, 255, 255);
            hovered = false;
        }

        fill(c);
        stroke(c);
        rectMode(CENTER);
        rectpos = map(val, min, max, xpos, xpos + length);
        rectpos = constrain(rectpos, xpos, (xpos + length));
        rect(rectpos, ypos, rectw, recth);

        if (mouseClicked && hovered)
        {
            dragging = true;
        }
        else if (!mousePressed)
        {
            dragging = false;
        }

        if (mousePressed & dragging)
        {
            rectpos = mouseX/scaleX;
            rectpos = constrain(rectpos, xpos, (xpos + length));
        }

        val = map(rectpos, xpos, xpos + length, min, max);
    }

}