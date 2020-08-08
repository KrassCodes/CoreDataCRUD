import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Animals.entity(), sortDescriptors: []) var animals: FetchedResults<Animals>
    @State private var newAnimalName = ""
    @State private var selectedAnimal: Animals?
    
    var body: some View {
        VStack{
            TextField("Add new", text: self.$newAnimalName).multilineTextAlignment(.center)
            Button("Save") {self.save(animal: self.selectedAnimal)}
            List{
                ForEach(animals, id: \.self) { animal in
                    Text("\(animal.name!)")
                        .onTapGesture {
                            self.newAnimalName = animal.name!
                            self.selectedAnimal = animal
                    }
                }
                .onDelete{ indexSet in
                    for index in indexSet {
                        self.context.delete(self.animals[index])
                        try? self.context.save()
                    }
                }
            }
        }
    }
    
    func save(animal: Animals?) {
        if self.selectedAnimal == nil {
            let newAnimal = Animals(context: self.context)
            newAnimal.name = newAnimalName
            try? self.context.save()
        } else {
            context.performAndWait {
                animal!.name = self.newAnimalName
                try? context.save()
                self.newAnimalName = ""
                self.selectedAnimal = nil
            }
        }
    }
}
