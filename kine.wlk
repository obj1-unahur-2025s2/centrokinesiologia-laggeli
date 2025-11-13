class Paciente {
  const property edad
  var property nivelDeDolor
  var property nivelFortaleza
  const rutina 
  method usarAparato(unAparato) { unAparato.serUsado(self) }
  method puedeUsarAparato(unAparato) = unAparato.puedeSerUsado(self)
  method puedeHacerRutina() = rutina.all({a => self.puedeUsarAparato(a)})
  method realizarRutina() {
    if (self.puedeHacerRutina()) {
      rutina.forEach({a => self.usarAparato(a)})
    }
  }
  method initialize() {
    if (edad < 0) { self.error("La edad tiene que ser mayor a 0") }
    if (nivelDeDolor < -1) { self.error("El nivel de dolor no puede ser negativo") }
    if (nivelFortaleza < -1) { self.error("La fortaleza no puede ser negativa") }
  }
}

class PacienteResistente inherits Paciente {
  override method realizarRutina() {
    super()
    self.nivelFortaleza(self.nivelFortaleza() + rutina.size())
  }
}

class PacienteCaprichoso inherits Paciente {
  override method puedeUsarAparato(unAparato) = super(unAparato) and rutina.any({a => a.color() == "Rojo"})
  override method realizarRutina() {
    super()
    super()
  }
}

class PacienteRapidaRecuperacion inherits Paciente {
  var dolorADecrementar = 3
  override method realizarRutina() {
    super()
    self.nivelDeDolor(self.nivelDeDolor() - dolorADecrementar)
  }
  method cambiarDolorADecrementar(dolor) { dolorADecrementar = dolor }
}

class Aparato {
  var property color = "Blanco"
  method serUsado(unPaciente) { 
    if (unPaciente.puedeUsarAparato(self)) { self.consecuenciasDeUso(unPaciente) }
  }
  method puedeSerUsado(unPaciente) 
  method pintar(unColor) { color = unColor }
  method consecuenciasDeUso(unPaciente)
  method necesitaMantenimiento()
  method realizarMantenimiento()
}

class Magneto inherits Aparato {
  var imantacion = 800
  override method serUsado(unPaciente) { 
    super(unPaciente)
    unPaciente.nivelDeDolor(unPaciente.nivelDeDolor() * 0.90)
  }
  override method puedeSerUsado(unPaciente) = true
  override method consecuenciasDeUso(unPaciente) { imantacion = (imantacion - 1).max(0) }
  override method necesitaMantenimiento() = imantacion < 100
  override method realizarMantenimiento() { imantacion += 500 }
}

class Bicicleta inherits Aparato {
  var property seDesajustaronTornillos = 0
  var property perdioAceite = 0
  override method serUsado(unPaciente) { 
    super(unPaciente)
    unPaciente.nivelDeDolor(unPaciente.nivelDeDolor() - 4)
    unPaciente.nivelFortaleza(unPaciente.nivelFortaleza() + 3) 
  } 
  override method puedeSerUsado(unPaciente) = unPaciente.edad() > 8
  override method consecuenciasDeUso(unPaciente) {
    if (unPaciente.edad() > 30) { seDesajustaronTornillos += 1 }
    if (unPaciente.edad().between(30, 50)) { perdioAceite += 1 }
  }
  override method necesitaMantenimiento() = seDesajustaronTornillos >= 10 or perdioAceite >= 5
  override method realizarMantenimiento() {
    seDesajustaronTornillos = 0
    perdioAceite = 0
  }
}

class Minitramp inherits Aparato {
  override method serUsado(unPaciente) { 
    super(unPaciente)
    unPaciente.nivelFortaleza(unPaciente.nivelFortaleza() + (unPaciente.edad() * 0.10)) 
  }
  override method puedeSerUsado(unPaciente) = unPaciente.nivelDeDolor() < 20
  override method consecuenciasDeUso(unPaciente) {}
  override method necesitaMantenimiento() = false
  override method realizarMantenimiento() {}
}

object centroKinesiologia {
  const aparatos = #{}
  const pacientes = #{}
  method agregarAparato(unAparato) { aparatos.add(unAparato) }
  method agregarPaciente(unPaciente) { pacientes.add(unPaciente) }
  method sacarAparato(unAparato) { aparatos.remove(unAparato) }
  method sacarPaciente(unPaciente) { pacientes.remove(unPaciente) }
  method colorDeAparatosSinRepetidos() = aparatos.map({a => a.color()}).asSet()
  method pacientesMenoresDe8Años() = pacientes.filter({p => p.edad() < 8})
  method cantidadQueNoPuedenHacerRutina() = pacientes.count({p => !p.puedeHacerRutina()})
  method estáEnÓptimasCondiciones() = aparatos.all({a => !a.necesitaMantenimiento()})
  method estáComplicado() = aparatos.count({a => a.necesitaMantenimiento()}) >= (aparatos.size() / 2)
  method visitaDeTécnico() { aparatos.forEach({a => a.realizarMantenimiento()}) }
}