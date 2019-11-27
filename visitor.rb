# A interface Component declara um método `accept` que deve considerar
# a interface do visitante base como argumento.
class Component
  # @abstract
  #
  # @param [Visitor] visitor
  def accept(_visitor)
    raise NotImplementedError, "#{self.class} não implementou o método '#{__method__}'"
  end
end

# Cada componente concreto deve implementar o método `accept` de forma que chame 
# o método do visitante correspondente à classe do componente.
class ConcreteComponentA < Component
  # Observe que estamos chamando `visitConcreteComponentA`, que corresponde ao nome
  # da classe atual. Dessa forma, informamos ao visitante a classe do componente com o qual trabalha.
  def accept(visitor)
    visitor.visit_concrete_component_a(self)
  end

  # Os componentes de concreto podem ter métodos especiais que 
  # não existem em sua classe base ou interface. O Visitor ainda 
  # pode usar esses métodos, pois está ciente da classe concreta do componente.
  def exclusive_method_of_concrete_component_a
    'A'
  end
end

# Mesmo aqui: visit_concrete_component_b => ConcreteComponentB
class ConcreteComponentB < Component
  # @param [Visitor] visitor
  def accept(visitor)
    visitor.visit_concrete_component_b(self)
  end

  def special_method_of_concrete_component_b
    'B'
  end
end

# A Interface do visitante declara um conjunto de métodos de visita que
# correspondem às classes de componentes. A assinatura de um método 
# de visita permite ao visitante identificar a classe exata do componente 
# com o qual está lidando.
class Visitor
  # @abstract
  #
  # @param [ConcreteComponentA] element
  def visit_concrete_component_a(_element)
    raise NotImplementedError, "#{self.class} não implementou o método '#{__method__}'"
  end

  # @abstract
  #
  # @param [ConcreteComponentB] element
  def visit_concrete_component_b(_element)
    raise NotImplementedError, "#{self.class} não implementou o método '#{__method__}'"
  end
end

# Os visitantes concretos implementam várias versões do mesmo algoritmo,
# que pode trabalhar com todas as classes de componentes concretos.
#
# Você pode experimentar o maior benefício do padrão Visitor ao usá-lo
# com uma estrutura de objeto complexa, como uma árvore composta. Nesse caso,
# pode ser útil armazenar algum estado intermediário do algoritmo enquanto
# executar métodos de visitantes sobre vários objetos da estrutura.
class ConcreteVisitor1 < Visitor
  def visit_concrete_component_a(element)
    puts "#{element.exclusive_method_of_concrete_component_a} + #{self.class}"
  end

  def visit_concrete_component_b(element)
    puts "#{element.special_method_of_concrete_component_b} + #{self.class}"
  end
end

class ConcreteVisitor2 < Visitor
  def visit_concrete_component_a(element)
    puts "#{element.exclusive_method_of_concrete_component_a} + #{self.class}"
  end

  def visit_concrete_component_b(element)
    puts "#{element.special_method_of_concrete_component_b} + #{self.class}"
  end
end

# O código do cliente pode executar operações do visitante sobre qualquer conjunto de
# elementos sem descobrir suas classes concretas. A operação de aceitação direciona uma
# chamada para a operação apropriada no objeto visitante.
def client_code(components, visitor)
  # ...
  components.each do |component|
    component.accept(visitor)
  end
  # ...
end

components = [ConcreteComponentA.new, ConcreteComponentB.new]

puts 'O código do cliente funciona com todos os visitantes através da interface base do visitante:'
visitor1 = ConcreteVisitor1.new
client_code(components, visitor1)

puts 'Ele permite que o mesmo código do cliente funcione com diferentes tipos de visitantes:'
visitor2 = ConcreteVisitor2.new
client_code(components, visitor2)
