<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:include page="/restaurant/partials/menu.jsp"/>

<div class="main-content">
    <div class="wrapper">
        <h1>Change Password</h1>
        <br><br>

        <form action="" method="POST">

            <table class="tbl-30">
                <tr>
                    <td>Old password: </td>
                    <td>
                        <input type="text" name="current_password" placeholder="Enter your current password">
                    </td>
                </tr>

                <tr>
                    <td>New Password: </td>
                    <td>
                        <input type="text" name="new_password" placeholder="Enter your new password">
                    </td>
                </tr>

				<tr>
                    <td>Confirm Password: </td>
                    <td>
                        <input type="text" name="confirm_password" placeholder="Confirm your new password">
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2">
                    	<input type="hidden" name="id" value="${adminUpdate.id }">
                        <input type="submit" name="submit" value="Update Admin" class="btn-secondary">
                    </td>
                </tr>
            </table>

        </form>
    </div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />