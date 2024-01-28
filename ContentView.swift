//
//  ContentView.swift
//  MoneyBuddyPOC
//
//  Created by Christopher Johnson on 1/27/24.
//
import Foundation
import SwiftUI
import Charts
struct ContentView: View {
    @State var isLoginValid:Bool = false
    var body: some View {
        if !isLoginValid{
            LoginView(isLoginValid: $isLoginValid)
        } else {
            MainBodyView()
        }
    }
}

//content view of main page - placeholder.
struct LoginView: View {
    //strings to contain u/p for authentication
    @State private var username = "";
    @State private var password = "";
    
    //Store color attributes for u/p fields (will be 2 when wrong!)
    @State private var wrongUser = 0;
    @State private var wrongPass = 0;
    
    //bool indicating whether to show success screen or not.
    @State private var showingLoginScreen = false;
    @Binding var isLoginValid: Bool
    var body: some View {
        
        //stylize the background a bit, gradient layering thanks to Z stack struct.
        ZStack{
            Color.green
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 25)
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
                .frame(width: 200, height: 300)
            RoundedRectangle(cornerRadius: 25)
                .scale(1.35)
                .foregroundColor(.white)
                .frame(width: 200, height: 300)
            
            
            //Vertically stack login UI elems - labels and fields and buttons!
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .frame(width: 250, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(15)
                    .border(.red,width: CGFloat(wrongUser)) //changes to the color we want
                
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 250, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(15)
                    .border(.red,width: CGFloat(wrongPass)) //changes to the color we want
                
                Button("Login"){
                    isLoginValid = authenticateUser(username: username, password: password)
                    
                    if(isLoginValid)
                    {
                        MainBodyView()
                        
                    }
                }
                .foregroundColor(.white)
                .frame(width: 250, height: 50)
                .background(Color.green)
                .cornerRadius(15)
               
                
            }.navigationBarHidden(true)
        }
        
    }
    
    //placeholder function, will replace w/ actual authentication functionality
    func authenticateUser(username: String, password: String) -> Bool {
        
        if username.lowercased() == "root" {
            wrongUser = 0
            if password.lowercased() == "tamuhackx2024" {
                wrongPass = 0
                return true;
            } else {
                wrongPass = 2
            }
        } else {
            wrongUser = 2
        }
        return false;
    }
}

//Dummy data to simulate the actual data type that will hold:
// Type: Is this expense rent, food, transit, etc?
// Cost: Double that will hold value it cost user
// whenRecurring: If this is a subscription, set to integer number of days between charges (0 indicates a one time fee)
struct testStruct: Identifiable{
    var id = UUID().uuidString
    var name: String = "test";
    var amount: Int = 0;

}

//Main body view holds the content following a successful loging attempt.
//Created nested views so that user does not get lost in navigating
//Additional views meant to be kept simple and lightweight to keep attention
struct MainBodyView: View {
    @State var showLearningView = false
    @State var showBudgetView = false
    @State var showExpenseView = false
    @State var newExpenseStr = ""
    var biggestCost = "Category A"
    var body: some View {
        ZStack{
            Color.green.opacity(0.4)
                .ignoresSafeArea()
          
            VStack {
                Text("Spending Summary")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .padding()
                
                //Placeholder, will be derived from PDF Bank/CC statements.
                @State var data = [
                    testStruct(
                        name: "Category A",
                        amount: 10),
                    
                    testStruct(
                        name: "Category B",
                        amount: 20),
                    
                    testStruct(
                        name: "Category C",
                        amount: 30)]
                //Create Donut Chart (with attempted interactability)
                Chart {
                    ForEach(data) { d in
                        SectorMark(
                            angle: .value("Sales", d.amount),
                            innerRadius: .ratio(0.614),
                            angularInset: 1)
                        .foregroundStyle(by: .value("Name", d.name))
                        .cornerRadius(25)
                        //     .opacity(d.name == selectedName ? 1.0 : 0.3)
                    }
                    //  .chartAngleSelection(value: $selectedAngle)
                }
                
                //Padding elements to make graph element smaller
                .padding()
                .padding()
                
                
                .chartBackground {ChartProxy in
                    GeometryReader { geometry in
                        let frame = geometry[ChartProxy.plotAreaFrame]
                        VStack {
                            Text("Biggest Cost") //Add options for most frequent, and other metrics
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text(biggestCost)
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                        .position(x: frame.midX, y: frame.midY)
                        
                    }
                }
                .padding()
                NavigationStack {
                    VStack{
                        
                        Button(action: {showLearningView = true}) {
                            Text("Daily Finance Tip")
                        }
                        .navigationDestination(isPresented: $showLearningView) {
                                    LearningView()
                        }
                        
                        Button(action: {showBudgetView = true})
                        {
                            Text("Create a Budget")
                        }
                        .navigationDestination(isPresented: $showBudgetView) {
                            BudgetView()
                        }
                        
                        .padding()
                        Button(action: {showExpenseView = true})
                        {
                            
                            Text("Add an Expense")
                        }
                        .navigationDestination(isPresented: $showExpenseView) {
                            AddExpenseView()
                        }
                        
                    }
                    
                }
                .frame(width: 300,height: 250)
                .cornerRadius(20)
                .foregroundColor(.green)
                .padding()
                
            }
        }
    }
    
    struct AddExpenseView: View {
        var body: some View {
            @State var value = ""
            
            
            Text("Scan a receipt or type in a value : )")
            HStack{
                TextField("Enter Amount up to two decimals", text:$value)
                    .padding()
                    
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(15)
                    .frame(width: 100)
                Menu {
                    Button {
                        // do something
                        value = "1232"
                        Text(value)
                    } label: {
                        Text("Category A")
                        Image(systemName: "arrow.down.right.circle")
                    }
                    Button {
                        // do something
                    } label: {
                        Text("Category B")
                        Image(systemName: "arrow.up.and.down.circle")
                    }
                    Button {
                        // do something
                        
                    } label: {
                        Text("Category C")
                        Image(systemName: "arrow.up.and.down.circle")
                        
                    }
                } label: {
                     Text("Type")
                     Image(systemName: "tag.circle")
                }
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(15)
                    .frame(width: 100)
                
                    
            }
            Button("Add Expense")
            {
               //Records new value by adding it to category/categories.
               //Left unfinished to prioritze other proof of concept implementations
            }
            
                
        }
    }
    
    
    struct BudgetView: View {
        var body: some View {
            @State var categoryA = ""
            @State var categoryB = ""
            @State var categoryC = ""
                TextField("Category A Amt", text:$categoryA)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(15)
                    .frame(width: 200)
            TextField("Category B Amt ", text:$categoryA)
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(15)
                .frame(width: 200)
                
            
            TextField("Category C Amt", text:$categoryA)
                .padding()
                .background(Color.black.opacity(0.05))
                .cornerRadius(15)
                .frame(width: 200)
              
        }
    }
    
    //Container for web scraper API to grab top finance article for that calendar day
    struct LearningView: View {
        var body: some View {
            Text("Lets get better today. Here's three top finance articles!")
        }
    }
    
    
}

//PreviewProvider allows canvas in xcode to be display (Dev only)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

    
