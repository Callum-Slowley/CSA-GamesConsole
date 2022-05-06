//------------------------------------------------------------------------------
// <auto-generated>
//     This code was auto-generated by com.unity.inputsystem:InputActionCodeGenerator
//     version 1.1.0
//     from Assets/InputMapping/MainInputMapping.inputactions
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public partial class @MainInputMapping : IInputActionCollection2, IDisposable
{
    public InputActionAsset asset { get; }
    public @MainInputMapping()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""MainInputMapping"",
    ""maps"": [
        {
            ""name"": ""MainGameInput"",
            ""id"": ""a3e12e9a-84ec-4bef-9ffb-57a1d29b8464"",
            ""actions"": [
                {
                    ""name"": ""Move"",
                    ""type"": ""Value"",
                    ""id"": ""6c28fe62-5783-46b7-9946-9c690a1e1fb2"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": ""StickDeadzone(min=0.2)"",
                    ""interactions"": """"
                },
                {
                    ""name"": ""CamMove"",
                    ""type"": ""Value"",
                    ""id"": ""3ff9a2c4-d252-40a4-9b5e-b056da7a28af"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Thing"",
                    ""type"": ""Button"",
                    ""id"": ""36195cef-05b0-496c-b1a2-6091e49343ec"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""AimMove"",
                    ""type"": ""Button"",
                    ""id"": ""3cabbf79-bf19-422e-8088-82a1d1a2458e"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Shoot"",
                    ""type"": ""Button"",
                    ""id"": ""490d58cc-aa5c-4763-981c-8ca1ef7cdb6f"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": """",
                    ""interactions"": ""Press""
                },
                {
                    ""name"": ""AButton"",
                    ""type"": ""Button"",
                    ""id"": ""539618d2-a6f8-43da-8a20-66327b70e017"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                },
                {
                    ""name"": ""YButton"",
                    ""type"": ""Button"",
                    ""id"": ""b262f8c6-e837-464d-84b1-6a52eb859901"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                },
                {
                    ""name"": ""BackButton"",
                    ""type"": ""Button"",
                    ""id"": ""7bb58118-213d-4290-a957-98010b0ad60a"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                },
                {
                    ""name"": ""DPAD_Up"",
                    ""type"": ""Button"",
                    ""id"": ""f88827cf-8f8b-4c8f-88a8-b2fb6e4de8bf"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                },
                {
                    ""name"": ""DPAD_Down"",
                    ""type"": ""Button"",
                    ""id"": ""d9e60734-d167-4240-95d0-f51baecd28a6"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                },
                {
                    ""name"": ""DPAD_Left"",
                    ""type"": ""Button"",
                    ""id"": ""b0cc23c7-efa4-4715-a0f3-b309547dd77e"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                },
                {
                    ""name"": ""DPAD_Right"",
                    ""type"": ""Button"",
                    ""id"": ""f5387350-8573-4e62-80f6-923e10e364f1"",
                    ""expectedControlType"": ""Button"",
                    ""processors"": ""AxisDeadzone"",
                    ""interactions"": ""Press(behavior=1)""
                }
            ],
            ""bindings"": [
                {
                    ""name"": """",
                    ""id"": ""cfe8b071-0288-4e43-a2f2-0b846d42034b"",
                    ""path"": ""<Gamepad>/leftStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""2D Vector"",
                    ""id"": ""9839e14c-f0f2-48d0-8332-800544c8713d"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""323e5daa-a013-4c37-b8f1-f93a132475ab"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""2a71266d-d3ce-4b34-a095-7f4f9f79dee2"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""36779ad3-f011-43e2-9e58-061b628b766d"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""8f5749ca-6351-473c-803a-b39bf3ccca56"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Move"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""d8c83136-2750-4f4d-a570-aec717462f5e"",
                    ""path"": ""<Gamepad>/rightStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""CamMove"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""a59fc659-953f-4a2e-9472-8fcc3e763377"",
                    ""path"": ""<Mouse>/delta"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""CamMove"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""2af9dab1-c17f-458d-8d61-4020e37b4bc8"",
                    ""path"": """",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Thing"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""ed7a26ee-a3b0-4785-970b-e79236ae710a"",
                    ""path"": ""<Gamepad>/rightStick"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""AimMove"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""96f3c283-bbd6-4efe-8e57-4afd08e7c596"",
                    ""path"": ""<Mouse>/delta"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""AimMove"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""b2f48192-e80b-4338-bd41-4963744d132c"",
                    ""path"": ""<Gamepad>/rightShoulder"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Shoot"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""67f65a4c-3984-49cf-b30e-410e4a1a51d3"",
                    ""path"": ""<Mouse>/leftButton"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Shoot"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""29919c15-a019-4ba9-b98e-85622b07abc5"",
                    ""path"": ""<Gamepad>/buttonEast"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""AButton"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""d32a1be8-a8d0-4665-ae25-7c9bec9efe10"",
                    ""path"": ""<Gamepad>/buttonNorth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""YButton"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""eb9b8e99-4da6-49fa-85d3-e55662626db2"",
                    ""path"": ""<Gamepad>/buttonSouth"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""BackButton"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""cf584c1d-10cf-4607-9a7f-6fa0d0f933ec"",
                    ""path"": ""<Gamepad>/dpad/up"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DPAD_Up"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""7c6185b0-b635-409f-baca-b0f25a506b97"",
                    ""path"": ""<Gamepad>/dpad/down"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DPAD_Down"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""9c7b7d3b-c54a-4c56-8c5a-38c86c87424f"",
                    ""path"": ""<Gamepad>/dpad/left"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DPAD_Left"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": """",
                    ""id"": ""1b0deb4b-3dac-49d7-b4e3-8768af6fb6d4"",
                    ""path"": ""<Gamepad>/dpad/right"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""DPAD_Right"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": [
        {
            ""name"": ""New control scheme"",
            ""bindingGroup"": ""New control scheme"",
            ""devices"": [
                {
                    ""devicePath"": ""<Gamepad>"",
                    ""isOptional"": false,
                    ""isOR"": false
                }
            ]
        }
    ]
}");
        // MainGameInput
        m_MainGameInput = asset.FindActionMap("MainGameInput", throwIfNotFound: true);
        m_MainGameInput_Move = m_MainGameInput.FindAction("Move", throwIfNotFound: true);
        m_MainGameInput_CamMove = m_MainGameInput.FindAction("CamMove", throwIfNotFound: true);
        m_MainGameInput_Thing = m_MainGameInput.FindAction("Thing", throwIfNotFound: true);
        m_MainGameInput_AimMove = m_MainGameInput.FindAction("AimMove", throwIfNotFound: true);
        m_MainGameInput_Shoot = m_MainGameInput.FindAction("Shoot", throwIfNotFound: true);
        m_MainGameInput_AButton = m_MainGameInput.FindAction("AButton", throwIfNotFound: true);
        m_MainGameInput_YButton = m_MainGameInput.FindAction("YButton", throwIfNotFound: true);
        m_MainGameInput_BackButton = m_MainGameInput.FindAction("BackButton", throwIfNotFound: true);
        m_MainGameInput_DPAD_Up = m_MainGameInput.FindAction("DPAD_Up", throwIfNotFound: true);
        m_MainGameInput_DPAD_Down = m_MainGameInput.FindAction("DPAD_Down", throwIfNotFound: true);
        m_MainGameInput_DPAD_Left = m_MainGameInput.FindAction("DPAD_Left", throwIfNotFound: true);
        m_MainGameInput_DPAD_Right = m_MainGameInput.FindAction("DPAD_Right", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }
    public IEnumerable<InputBinding> bindings => asset.bindings;

    public InputAction FindAction(string actionNameOrId, bool throwIfNotFound = false)
    {
        return asset.FindAction(actionNameOrId, throwIfNotFound);
    }
    public int FindBinding(InputBinding bindingMask, out InputAction action)
    {
        return asset.FindBinding(bindingMask, out action);
    }

    // MainGameInput
    private readonly InputActionMap m_MainGameInput;
    private IMainGameInputActions m_MainGameInputActionsCallbackInterface;
    private readonly InputAction m_MainGameInput_Move;
    private readonly InputAction m_MainGameInput_CamMove;
    private readonly InputAction m_MainGameInput_Thing;
    private readonly InputAction m_MainGameInput_AimMove;
    private readonly InputAction m_MainGameInput_Shoot;
    private readonly InputAction m_MainGameInput_AButton;
    private readonly InputAction m_MainGameInput_YButton;
    private readonly InputAction m_MainGameInput_BackButton;
    private readonly InputAction m_MainGameInput_DPAD_Up;
    private readonly InputAction m_MainGameInput_DPAD_Down;
    private readonly InputAction m_MainGameInput_DPAD_Left;
    private readonly InputAction m_MainGameInput_DPAD_Right;
    public struct MainGameInputActions
    {
        private @MainInputMapping m_Wrapper;
        public MainGameInputActions(@MainInputMapping wrapper) { m_Wrapper = wrapper; }
        public InputAction @Move => m_Wrapper.m_MainGameInput_Move;
        public InputAction @CamMove => m_Wrapper.m_MainGameInput_CamMove;
        public InputAction @Thing => m_Wrapper.m_MainGameInput_Thing;
        public InputAction @AimMove => m_Wrapper.m_MainGameInput_AimMove;
        public InputAction @Shoot => m_Wrapper.m_MainGameInput_Shoot;
        public InputAction @AButton => m_Wrapper.m_MainGameInput_AButton;
        public InputAction @YButton => m_Wrapper.m_MainGameInput_YButton;
        public InputAction @BackButton => m_Wrapper.m_MainGameInput_BackButton;
        public InputAction @DPAD_Up => m_Wrapper.m_MainGameInput_DPAD_Up;
        public InputAction @DPAD_Down => m_Wrapper.m_MainGameInput_DPAD_Down;
        public InputAction @DPAD_Left => m_Wrapper.m_MainGameInput_DPAD_Left;
        public InputAction @DPAD_Right => m_Wrapper.m_MainGameInput_DPAD_Right;
        public InputActionMap Get() { return m_Wrapper.m_MainGameInput; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(MainGameInputActions set) { return set.Get(); }
        public void SetCallbacks(IMainGameInputActions instance)
        {
            if (m_Wrapper.m_MainGameInputActionsCallbackInterface != null)
            {
                @Move.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnMove;
                @Move.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnMove;
                @Move.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnMove;
                @CamMove.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnCamMove;
                @CamMove.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnCamMove;
                @CamMove.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnCamMove;
                @Thing.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnThing;
                @Thing.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnThing;
                @Thing.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnThing;
                @AimMove.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnAimMove;
                @AimMove.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnAimMove;
                @AimMove.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnAimMove;
                @Shoot.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnShoot;
                @Shoot.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnShoot;
                @Shoot.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnShoot;
                @AButton.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnAButton;
                @AButton.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnAButton;
                @AButton.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnAButton;
                @YButton.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnYButton;
                @YButton.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnYButton;
                @YButton.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnYButton;
                @BackButton.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnBackButton;
                @BackButton.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnBackButton;
                @BackButton.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnBackButton;
                @DPAD_Up.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Up;
                @DPAD_Up.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Up;
                @DPAD_Up.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Up;
                @DPAD_Down.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Down;
                @DPAD_Down.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Down;
                @DPAD_Down.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Down;
                @DPAD_Left.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Left;
                @DPAD_Left.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Left;
                @DPAD_Left.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Left;
                @DPAD_Right.started -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Right;
                @DPAD_Right.performed -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Right;
                @DPAD_Right.canceled -= m_Wrapper.m_MainGameInputActionsCallbackInterface.OnDPAD_Right;
            }
            m_Wrapper.m_MainGameInputActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Move.started += instance.OnMove;
                @Move.performed += instance.OnMove;
                @Move.canceled += instance.OnMove;
                @CamMove.started += instance.OnCamMove;
                @CamMove.performed += instance.OnCamMove;
                @CamMove.canceled += instance.OnCamMove;
                @Thing.started += instance.OnThing;
                @Thing.performed += instance.OnThing;
                @Thing.canceled += instance.OnThing;
                @AimMove.started += instance.OnAimMove;
                @AimMove.performed += instance.OnAimMove;
                @AimMove.canceled += instance.OnAimMove;
                @Shoot.started += instance.OnShoot;
                @Shoot.performed += instance.OnShoot;
                @Shoot.canceled += instance.OnShoot;
                @AButton.started += instance.OnAButton;
                @AButton.performed += instance.OnAButton;
                @AButton.canceled += instance.OnAButton;
                @YButton.started += instance.OnYButton;
                @YButton.performed += instance.OnYButton;
                @YButton.canceled += instance.OnYButton;
                @BackButton.started += instance.OnBackButton;
                @BackButton.performed += instance.OnBackButton;
                @BackButton.canceled += instance.OnBackButton;
                @DPAD_Up.started += instance.OnDPAD_Up;
                @DPAD_Up.performed += instance.OnDPAD_Up;
                @DPAD_Up.canceled += instance.OnDPAD_Up;
                @DPAD_Down.started += instance.OnDPAD_Down;
                @DPAD_Down.performed += instance.OnDPAD_Down;
                @DPAD_Down.canceled += instance.OnDPAD_Down;
                @DPAD_Left.started += instance.OnDPAD_Left;
                @DPAD_Left.performed += instance.OnDPAD_Left;
                @DPAD_Left.canceled += instance.OnDPAD_Left;
                @DPAD_Right.started += instance.OnDPAD_Right;
                @DPAD_Right.performed += instance.OnDPAD_Right;
                @DPAD_Right.canceled += instance.OnDPAD_Right;
            }
        }
    }
    public MainGameInputActions @MainGameInput => new MainGameInputActions(this);
    private int m_NewcontrolschemeSchemeIndex = -1;
    public InputControlScheme NewcontrolschemeScheme
    {
        get
        {
            if (m_NewcontrolschemeSchemeIndex == -1) m_NewcontrolschemeSchemeIndex = asset.FindControlSchemeIndex("New control scheme");
            return asset.controlSchemes[m_NewcontrolschemeSchemeIndex];
        }
    }
    public interface IMainGameInputActions
    {
        void OnMove(InputAction.CallbackContext context);
        void OnCamMove(InputAction.CallbackContext context);
        void OnThing(InputAction.CallbackContext context);
        void OnAimMove(InputAction.CallbackContext context);
        void OnShoot(InputAction.CallbackContext context);
        void OnAButton(InputAction.CallbackContext context);
        void OnYButton(InputAction.CallbackContext context);
        void OnBackButton(InputAction.CallbackContext context);
        void OnDPAD_Up(InputAction.CallbackContext context);
        void OnDPAD_Down(InputAction.CallbackContext context);
        void OnDPAD_Left(InputAction.CallbackContext context);
        void OnDPAD_Right(InputAction.CallbackContext context);
    }
}
