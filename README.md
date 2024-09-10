# Progetto di Reti Logiche 2023-2024 
Funzione seno in virgola fissa

Il modulo progettato calcola il seno di un angolo ricevuto in input mediante interpolazione lineare basandosi su valori noti della funzione.
I valori prestabiliti del seno sono relativi agli angoli multipli di 8 del primo quadrante oltre che agli angoli pari a 89° e 90°.

schema a blocchi del componente:

![image](https://github.com/user-attachments/assets/5ea94abe-77dd-4756-b86a-7134e3a16e1a)


Il modulo ricorre inoltre le seguenti identità trigonometriche:

  $sin⁡(\theta)=sin⁡(180-\theta)$  se  $\theta \in (90;180]$

  $sin⁡(\theta)=-sin⁡(\theta-180)$  se $\theta \in (180;270]$

  $sin⁡(\theta)= -sin⁡(360-\theta)$  se $\theta \in (270;360]$

Grazie alle quali è sufficiente conoscere i valori della funzione da 0° a 90° per poter ricondursi al risultato per qualsiasi angolo.

L’angolo in input è intero e può variare secondo la specifica da 0 a 359, è rappresentabile quindi su 9 bit (sono rappresentabili anche valori superiori a 359 ma produrranno una segnalazione di risultato invalido).

Il valore del seno in output è rappresentato su 10 bit in virgola fissa così organizzati:

i primi 2 bit più significativi per la parte intera, i restanti 8 bit per la parte decimale.

La funzione utilizzata per l’interpolazione è quella classica della retta passante per due punti:

$y=y_0 + \frac{(x-x_0)(y_1-y_0)}{8}$

Dove

$y$ è il valore approssimato del seno al per l’angolo x

$y_0,y_1$ sono i valori della funzione per l’angolo multiplo di 8 precedente e successivo all’angolo x 

$x_0$ è il multiplo di 8 precedente per x

Si noti che non compare il termine $x_1-x_0$ perché, dati gli intervalli considerati, è sempre = 8.

Esempio di interpolazione per sin⁡51:

![image](https://github.com/user-attachments/assets/22c317f5-88dc-4da3-baf4-a441793c20a3)


[documentazione completa](https://github.com/omgbarde/RTL_bardelli_final_project/blob/main/Relazione%20Bardelli.pdf)
