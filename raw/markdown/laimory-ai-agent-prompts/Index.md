## 처리 흐름                                                                                       
원본 데이터                                                                                                     
    ↓                                                                                                             
  Event Agents 병렬 처리                                                                                      
    ├─ Location                                                                                              
    ├─ Calendar                                                                                              
    ├─ Photo                                                                                                  
    ├─ Sleep/Activity                                                              
    └─ Notification                                                                                          
    ↓                                                                                                             
  후보(candidates)와 단서(fragments) 취합                                                                
    ↓                                                                                                             
  Timeline Agent가 하나의 하루 타임라인으로 병합                                                     
    ↓                                                                                                             
  Repair Agent가 오류·누락·중복을 검토하고 수정                                                        
    ↓                                                                                                             
  최종 타임라인                                                                                                                                                             
## 각 프롬프트 역할                                                                                                                                         
  - location/prompt.md                                                                                      
    위치·체류·이동 데이터를 실제 활동과 장소 방문으로 해석합니다.                                                                                                                                               
  - location/review.md                                                                                        
    Location Agent의 1차 결과에서 부자연스럽거나 근거가 약한 내용을 검토합니다.                                                                                                                           
  - calendar/prompt.md                                                                                      
    캘린더 일정을 활동 후보로 만들고, 실제 참석 여부의 불확실성을 표현합니다.                                                                                                            
  - notification/prompt.md                                                                                  
    알림을 대화·결제·예약·업무 등의 하루 단서로 해석합니다.                                                                                                                                     
  - photo/describe_vision_prompt.md                                                                    
    실제 이미지를 보고 사진 속 활동과 장소 단서를 설명합니다.                                                                                                                                  
  - photo/describe_prompt.md                                                                             
    이미지를 불러오지 못했을 때 촬영 시각과 GPS만으로 제한적인 설명을 만듭니다.                                                                                                                         
  - photo/prompt.md                       
    사진 설명을 식사·행사·휴식 같은 실제 활동 후보로 변환합니다.                                                                                                                    
  - sleep_activity/prompt.md                                                                                
    수면·기상·활동량 데이터를 하루 리듬과 활동 후보로 해석합니다.                                                                                                           

  - sleep_activity/review.md                                                                                 
    수면이나 기상 후보가 빠지지 않았는지 검토합니다.                                                                                                                                                        
  - timeline/timeline.md                                                                                     
    모든 Agent의 후보를 시간·장소·의미 기준으로 합쳐 최종 타임라인 초안을 만듭니다.                                                                                                  
  - repair/prompt.md                                                                                         타임라인의 누락·중복·근거 없는 내용·잘못된 시간을 찾아 수정합니다.  