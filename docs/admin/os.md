# Operating System

## 1. Overview

Operating System(OS)은 NABP에서  
**실제 배포 대상이 되는 OS 설치 정의를 관리하는 구성 요소**입니다.

OS 설정은 Installation Media, Partition Table, Provisioning Workflow를  
하나로 묶는 역할을 하며,  
Machine Group에서 참조되어 실제 배포에 사용됩니다.

Operating System 설정은  
NABP 구성 과정 중 **Provisioning Workflow 이후 단계**에 해당합니다.

---

## 2. Role of Operating System

Operating System은 다음 역할을 수행합니다.

- 배포 대상 OS의 논리적 정의
- Installation Media 연결
- Partition Table 지정
- Provisioning Workflow 연계
- OS별 Template 선택 및 파라미터 정의

OS는 실제 배포 작업의 **중앙 기준점** 역할을 합니다.

---

## 3. Configuration Path

Operating System은 다음 경로에서 설정합니다.

Contents  
→ Operating Systems

---

## 4. Operating System Creation Flow

Operating System 생성은 다음 순서로 진행됩니다.

1. OS 기본 정보 입력
2. Partition Table 지정
3. Installation Media 지정
4. Provisioning Workflow 지정
5. OS Template 설정
6. Parameters 설정

---

## 5. Basic Information

### 5.1 Name

- Operating System을 식별하기 위한 이름
- 일반적으로 OS 이름과 버전을 포함하여 작성

예시:
- CentOS_7.9
- AlmaLinux_9.2
- Ubuntu_22.04

---

### 5.2 OS Family

- OS 계열 선택
- Template 및 Media 필터 기준으로 사용됨

예시:
- RedHat
- Debian
- SUSE

---

### 5.3 Architecture

- OS가 설치될 시스템 아키텍처
- 일반적으로 x86_64 사용

---

## 6. Partition Table Configuration

Operating System에서는  
OS 설치 시 사용할 Partition Table을 지정합니다.

- Kickstart 기반 OS의 경우 기본 Partition Template 사용 가능
- 기본 Template은 모든 디스크 초기화 후 자동 파티셔닝 수행

Partition Table 설정은  
OS 설치 방식(Diskfull / Diskless)에 직접적인 영향을 미칩니다.

---

## 7. Installation Media Configuration

Operating System은  
Installation Media 단계에서 정의한 Media Path를 참조합니다.

- OS 설치 이미지 다운로드
- Repository 경로 제공
- Health Check Live OS 이미지 참조

Media Path 접근 실패 시  
OS 설치는 진행되지 않습니다.

---

## 8. Provisioning Workflow Configuration

Operating System에서는  
해당 OS에 적용할 Provisioning Workflow를 지정합니다.

- OS_INSTALL 단계에서 실행될 Template 선택
- Kickstart / Preseed Template 지정
- OS별 배포 로직 분기 처리

Provisioning Workflow는  
Machine Group 및 ZTP Template과 함께 동작합니다.

---

## 9. OS Template Configuration

Operating System에서는  
OS 배포에 사용될 Template을 선택합니다.

- Provisioning Template  
  예: kickstart, preseed

- Bootloader Template  
  예: grub, grubx64.efi

- iPXE Template (선택)

- PXELinux Template (선택)

- OS Default Configuration Template

Template 선택은  
OS 부팅 및 설치 방식에 직접적인 영향을 미칩니다.

---

## 10. Parameters Configuration

Operating System 단계에서는  
OS 설치에 필요한 추가 파라미터를 정의할 수 있습니다.

예시:
- locale
- timezone
- keyboard
- network options
- custom install flags

정의된 파라미터는  
Provisioning Template에서 참조됩니다.

---

## 11. Usage with Machine Group

Operating System은  
Machine Group 생성 시 선택되어 사용됩니다.

- OS 정의는 Machine Group에 연결됨
- Machine Group은 OS 설정을 상속
- ZTP Template 생성 시 기준 정보로 사용

OS 설정 변경 시  
해당 OS를 사용하는 Machine Group에 영향을 미칩니다.

---

## 12. Best Practices

- OS 버전별로 별도 정의
- Production / Test OS 분리 관리
- OS 변경 시 Machine Group 영향도 검토
- Template 수정 시 사전 테스트 수행

---

## 13. Common Issues

- OS Family 불일치
- Installation Media 경로 오류
- Partition Template 오류
- Workflow Template 누락
- Bootloader Template 설정 오류

문제 발생 시  
OS 설정과 연결된 구성 요소를  
우선적으로 점검해야 합니다.

---

## 14. Related Configuration

Operating System은 다음 구성 요소와 연관됩니다.

- Installation Media
- Partition Table
- Provisioning Workflow
- Machine Group
- ZTP Template

