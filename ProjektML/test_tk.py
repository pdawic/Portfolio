from tkinter import *
okno = Tk()                 # uruchamiam okno dialogowe
okno.title("Prognoza") # napis na ramce
okno.geometry('500x500')         #wielkość okna

tekst_1 = Label(okno, text="Podaj dane do prognozy")   # wprowadza napis do okna
tekst_1.grid(column=0, row=0)    # zdefiniowanie gdzie ten napis ma sie znajdować
wartosc_prognozy = Entry(okno,width=10)   # wycięcie do prognozy
wartosc_prognozy.grid(column=1, row=0)    # zdefiniowanie gdzie te wcięcie ma się znajdować
def clicked():              # definiuje funkcję
    tekst_2 = "Witamy Ciebie  " + wartosc_prognozy.get()   # to co wpisaliśmy tu się wyświetla
    tekst_1.configure(text= tekst_2)
przycisk = Button(okno, text="Naciśnij przycisk", command=clicked)
# naciśnij przycisk a uruchomi się funkcja
przycisk.grid(column=2, row=0) # położenie przycisku
okno.mainloop()                 #uruchomienie pętli