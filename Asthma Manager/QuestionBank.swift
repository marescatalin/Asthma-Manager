//
//  QuestionBank.swift

//

import Foundation

class QuestionBank {
    var list = [Question]()
    
    init() {
        // Creating a quiz item and appending it to the list
        let item = Question(text: "The use of indoor air-cleaning devices can vastly improve allergic asthma symptoms", correctAnswer: false, answerReason: "Indoor air-cleaning devices, such as high-efficiency particulate air and electrostatic precipitating filters, can reduce airborne dog and cat allergens, although most studies do not show them to have an effect on asthma symptoms or lung function. ")
        
        // Add the Question to the list of questions
        list.append(item)
        
        // skipping one step and just creating the quiz item inside the append function
        list.append(Question(text: "Asthma can be triggered as a result of thunderstorms.", correctAnswer: true, answerReason: "Case studies have indicated that during thunderstorms, asthma sufferers are at higher risks of asthma attacks."))
        
        list.append(Question(text: "I cough frequently during the middle of the night, after exercise, and when I am around cats, but I have never wheezed. This means that I do not have asthma.", correctAnswer: false, answerReason: "Asthma is not just wheezing. Some individuals with asthma never wheeze and wheezing does not have to be present for an individual to have asthma. Coughing, recurrent bronchitis, and shortness of breath are also ways that asthma appears. Please inform your health care provider of your symptoms and ask for appropriate care."))
        
        list.append(Question(text: "As a result of a thunderstorm the levels of pollen in the atmosphere increase significantly.", correctAnswer: true, answerReason: "During a thunderstorm, the air particles are spread out easier in the atmosphere due to the absorption of excess moistuire."))
        
        list.append(Question(text: "Asthma action plans are only for those individuals with asthma who do not understand their medications.", correctAnswer: false, answerReason: "Asthma action plans are useful for all individuals with asthma. These plans provide detailed instructions about how to treat asthma. They outline what medications to take for your asthma and when and how to increase the doses or add more medication if needed for symptoms. These plans also include advice about when to call your physician. An asthma action plan puts you in control for detection and early treatment of symptoms."))
        
        list.append(Question(text: "My child was recently diagnosed with asthma. She will not be able to do the things that other kids can and she may not be able to lead an active childhood.", correctAnswer: false, answerReason: "Asthma is a chronic disease that requires ongoing management. Personalized plans for treatment may include medications, an asthma action plan, and environmental control measures to avoid your child's asthma triggers. By working together with your daughter's health care provider on her treatment plan, you can ensure that her asthma is well controlled so that she can participate in all of her normal activities."))
        
        list.append(Question(text: "Asthma has different causes or triggers in different people. Allergies to environmental allergens, such as dust mites or molds, frequently contribute to asthma symptoms.", correctAnswer: true, answerReason: "Many people have allergic asthma, which means that exposure to allergens makes their symptoms worse. Common allergens include house dust mites, pet dander, molds, pollen, and cockroach droppings. Your allergist can diagnose what you are allergic to and recommend ways to avoid exposure to your triggers. Your allergist can also treat your allergies with medications and/or immunotherapy (allergy shots) which can diminish your allergies' effect on your asthma."))
        
        list.append(Question(text: "Once a child reaches puberty, they will outgrow their asthma.", correctAnswer: false, answerReason: "Many infants who wheeze with colds or viral respiratory tract infections will stop wheezing as they grow older. However, if your child has atopic dermatitis (eczema), allergies, or if there is smoking in the home or a strong family history of allergies or asthma, there is a much greater chance that his asthma symptoms will persist into adulthood."))
        
        list.append(Question(text: "Quick-relief or rescue medications for asthma, such as bronchodilators, may be taken on a daily basis to control frequent symptoms.", correctAnswer: false, answerReason: " Quick-relief medications are used to provide temporary relief of symptoms, but they are not meant to be taken daily unless for pre-treatment for exercise. Quick-relief medications include bronchodilators and are often referred to as rescue medications because they open up the airways quickly so that more air can flow through."))
        
        list.append(Question(text: "Pet birds don’t cause a problem for people with asthma.", correctAnswer: false, answerReason: "Pet birds can cause asthma flare-ups in some people—as can dogs and cats. This is because things such as fur, dry skin flakes (dander), feathers, droppings, and saliva may be asthma triggers."))
        
        list.append(Question(text: "Laughing or crying can trigger an asthma attacks.", correctAnswer: true, answerReason: "Laughing, crying, and feeling excited are triggers for some people. Stress and anxiety can also trigger asthma. You can’t avoid most of these normal emotions, but you can learn ways to slow your breathing and avert an attack."))
        
        list.append(Question(text: "It’s a myth that perfume can trigger asthma attacks.", correctAnswer: false, answerReason: "It’s not a myth. Perfume and other strong scents can trigger asthma flare-ups. Switch to unscented soap, lotion, toilet paper, and cleaning products. Use scent-free deodorant and lotion. Don’t use perfumes, air fresheners, potpourri, and other scented products."))
        
        list.append(Question(text: "Mold is a common cause of asthma attacks.", correctAnswer: true, answerReason: "Mold grows in damp places, such as bathrooms, basements, and closets. Clean damp areas weekly to prevent mold growth. This includes shower stalls and sinks. You may need someone to clean these areas for you. Or try wearing a mask. Run an exhaust fan while bathing. Or leave a window open in the bathroom. Repair water leaks in or around your home. Have someone else rake leaves, if possible."))
    }
    
    func firstQuestion() -> Question {
        return list.first!
    }
}
