#include <stdio.h>
#include <math.h>

int translate(int angle) {
    if (angle <= 90)
        return angle;
    else if (angle <= 180)
        return 180 - angle;
    else if (angle <= 270)
        return angle - 180;
    else
        return 360 - angle;
}

int eval(int angle) {
    if (angle <= 180)
        return 0;
    else
        return 1;
}

int sineLut(int angle) {
    switch (angle) {
        case 0:
            return 0;
        case 8:
            return 35;
        case 16:
            return 70;
        case 24:
            return 104;
        case 32:
            return 135;
        case 40:
            return 164;
        case 48:
            return 190;
        case 56:
            return 212;
        case 64:
            return 230;
        case 72:
            return 243;
        case 80:
            return 252;
        case 88:
            return 254;
        case 89:
            return 255;
        case 90:
            return 256;
        default:
            return 512; // dont care
    }
}

int interpolate(int x, int x_0, int y_0, int y_1) {
    return y_0 + ((x - x_0) * (y_1 - y_0) / 8);
}

int main() {
    int theta = 0;
    int theta_prime, sign, m1, m2, error, sine_int;
    double sine, sine_div;

    FILE *fd = fopen("data.txt", "w");

    while (theta < 360) {
        // printf("insert an angle:");
        // scanf("%d", &theta);

        if (theta < 360)
            error = 0;
        else
            error = 1;

        theta_prime = translate(theta);
        sign = eval(theta);

        if (theta_prime <= 87) {
            m1 = (theta_prime / 8) * 8;
            m2 = m1 + 8;
        } else {
            m1 = theta_prime;
            m2 = theta_prime;
        }

        sine = sin(3.14 / 180 * theta);
        sine_int = interpolate(theta_prime, m1, sineLut(m1), sineLut(m2));
        sine_div = (float)sine_int / 256;

        printf("Theta: %d\n", theta);
        printf("calculated sine: %d, with sign %d\n", sine_int, sign);
        printf("transformd sine: %lf\n", sine_div);
        printf("expected sine: %lf\n\n", sine);
        double error = fabs(sine) - fabs(sine_div);
        fprintf(fd, "%lf\n", error);

        theta++;
    }

    fprintf(fd, "\n");
    fclose(fd);

    return 0;
}