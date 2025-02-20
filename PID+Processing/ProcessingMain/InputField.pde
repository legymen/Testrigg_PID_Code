
class InputField {
    float xpos, ypos, w, h;
    String id;
    boolean activated = false;
    boolean clicked = false;
    ArrayList<Character> input;
    String inputstr;

    InputField(float _xpos, float _ypos, float _w, float _h, String _id)
    {
        xpos = _xpos;
        ypos = _ypos;
        w = _w;
        h = _h;
        id = _id;
        input = new ArrayList<Character>();
    }

    void update()
    {
        noFill();
        stroke(255,255,255);
        strokeWeight(1.0);
        rect(xpos, ypos, w, h);

        if (mouseClicked && mouseX > xpos - w/2 && mouseX < xpos + w/2 && mouseY < ypos + h/2 && mouseY > ypos - h/2)
        {
            clicked = true;
        }
        else if (mouseClicked)
        {
            clicked = false;
        }

        if (clicked && keyClicked && key != BACKSPACE && key != CODED)
        {
            input.add(key);
        }
        else if (clicked && keyClicked && key == BACKSPACE && key != CODED && input.size() > 0)
        {
            input.remove(input.size() - 1);
        }

        // If anything has been added to the inputfield, then write it out.
        if (input.size() > 0)
        {
            inputstr = "";
            for (int i = 0; i < input.size(); i++)
            {
                inputstr += input.get(i);
            }
            fill(255, 255, 255);
            textAlign(LEFT, CENTER);
            text(inputstr, xpos - w/2.20, ypos);
            textAlign(CENTER, CENTER);
        }
    }

    float getvalue()
    {   
        float val;
        try
        {
            val = float(inputstr);
        }
        catch (Exception e)
        {
            val = -1;
        }

        input.clear();
        return val;
    }
}