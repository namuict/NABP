# Provisioning Workflow

## 1. Overview

Provisioning Workflow는 NABP에서  
**OS 배포 과정 전체를 제어하는 실행 절차 정의 구성 요소**입니다.

Workflow는 여러 Template을  
순서와 조건에 따라 실행하도록 구성되며,  
ZTP 기반 자동 배포의 핵심 메커니즘입니다.

Provisioning Workflow는  
Partition Table 이후, Operating System 이전 단계에서 설정됩니다.

---

## 2. Role of Provisioning Workflow

Provisioning Workflow는 다음 역할을 수행합니다.

- OS 배포 단계 정의
- Template 실행 순서 제어
- 단계별 실행 조건 및 활성 여부 설정
- 배포 상태 및 Checkpoint 관리
- 배포 실패 시 중단 또는 재시도 제어

Workflow 설정은  
배포 안정성과 직결됩니다.

---

## 3. Configuration Path

Provisioning Workflow는 다음 경로에서 설정합니다.

Workflow  
→ Provisioning

---

## 4. Workflow Composition

Provisioning Workflow는  
여러 Template을 조합하여 구성됩니다.

Workflow는 다음 Template 유형을 포함할 수 있습니다.

- Provisioning Templates
- BIOS Setup Templates
- Platform Setup Templates
- Job Invocation Templates

각 Template은  
Workflow 내에서 특정 단계에 매핑됩니다.

---

## 5. Default Workflow Stages

NABP의 기본 Provisioning Workflow 단계는 다음과 같습니다.

REGISTERING  
→ HEALTH_CHECK  
→ BIOS_SETUP  
→ OS_INSTALL  
→ PLATFORM_SETUP  
→ DEPLOYED

각 단계는 독립적으로 활성 또는 비활성화할 수 있습니다.

---

## 6. Workflow Stage Description

### 6.1 REGISTERING

- 하드웨어 정보 수집
- BMC 기본 설정 수행
- 노드 식별 및 등록

---

### 6.2 HEALTH_CHECK

- CPU, Memory, Disk, Network 상태 점검
- 사전 조건 미충족 시 배포 중단
- Checkpoint 기반 결과 보고

---

### 6.3 BIOS_SETUP

- BIOS 설정 자동화
- IPMI 또는 Redfish 기반 제어
- OS 설치 전 하드웨어 환경 정렬

---

### 6.4 OS_INSTALL

- PXE 기반 OS 설치 수행
- Kickstart / Preseed Template 실행
- Installation Media 접근 및 이미지 다운로드

---

### 6.5 PLATFORM_SETUP

- OS 설치 이후 Post-Install 작업 수행
- 패키지 설치
- 환경 설정 및 커스터마이징

---

### 6.6 DEPLOYED

- 모든 Workflow 단계 완료
- 배포 성공 상태 전환
- 최종 Checkpoint 보고

---

## 7. Template Execution Control

각 Workflow 단계는  
다음 속성을 가질 수 있습니다.

- enabled  
  true 또는 false로 실행 여부 제어

- duration  
  단계별 예상 또는 제한 시간

- retry policy  
  실패 시 재시도 여부 및 횟수

---

## 8. Workflow Parameters

Workflow는  
Machine Group 및 ZTP Template에서 전달되는  
파라미터를 참조합니다.

대표적인 파라미터 예시는 다음과 같습니다.

- abp_workflow
- platform_type
- hypervisor_type
- custom execution flags

파라미터는  
Template 실행 로직에 직접 영향을 미칩니다.

---

## 9. Workflow Reuse and Clone

Provisioning Workflow는  
기존 Workflow를 복제하여 생성할 수 있습니다.

- 기본 Workflow 재사용 권장
- 검증된 Template 활용
- Clone Workflow를 통한 커스터마이징

Workflow 복제 시  
원본 이름 뒤에 Clone 식별자가 추가됩니다.

---

## 10. Usage with Operating System

Provisioning Workflow는  
Operating System 정의 시 선택됩니다.

- OS는 Workflow를 참조
- Machine Group은 OS 설정을 상속
- ZTP Template 생성 시 기준 Workflow로 사용

Workflow 변경 시  
해당 Workflow를 사용하는 OS 및 Machine Group에 영향을 미칩니다.

---

## 11. Workflow Execution in ZTP

Provisioning Workflow는  
ZTP Template 및 ZTP Dashboard 작업 실행 시 사용됩니다.

- Workflow 단계별 상태 표시
- 노드별 단계 진행 상황 확인
- Checkpoint 기반 시간 및 결과 분석

---

## 12. Best Practices

- 기본 Workflow 유지 후 필요 시 복제
- 단계별 Template 변경 시 사전 테스트
- Health Check 단계는 비활성화 권장하지 않음
- BIOS 설정 변경 시 벤더별 검증 필수

---

## 13. Common Issues

- Workflow 단계 누락
- Template 매핑 오류
- 파라미터 미전달
- Installation Media 접근 실패

문제 발생 시  
Workflow 단계와 Template 매핑을  
우선적으로 점검해야 합니다.

---

## 14. Related Configuration

Provisioning Workflow는 다음 구성 요소와 연관됩니다.

- Partition Table
- Installation Media
- Operating System
- Machine Group
- ZTP Template
- ZTP Dashboard
